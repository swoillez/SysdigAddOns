import requests
import datetime
import time
import socket
import sys
import os

# Read the parameters from the environment variables
# examples :
# export WEBSITE_URL="http://www.google.com" -> URL to test
# export METRIC_NAME=websiteResponseTime -> Name of the StatD metric
# export METRIC_LABELS=region="europe,team=marketing" -> Optionnal Labels
# export POOLING_INTERVAL=10 -> Pooling interval in seconds

try:
    url = os.environ["WEBSITE_URL"]
    print( "URL to test: " +url)
except:
    print >> sys.stderr, "WEBSITE_URL not defined"
    sys.exit(1)

try:
    name = os.environ["METRIC_NAME"]
except:
    print >> sys.stderr, "METRIC_NAME not defined"
    sys.exit(1)

try:
    labels = os.environ["METRIC_LABELS"]
except:
    labels = ""

try:
    interval = int(os.environ["CHECK_INTERVAL"])
except:
    print("No pooling interval provided. Default to 10sec")
    interval = 10

# Remove the https:// or http:// from the URL to auto create website label

sitename = url.replace("https://","")
sitename = sitename.replace("http://","")

# Auto add website label, then add extra labels

if(labels):
    strlabels = str("#website=" + sitename + "," + labels + ":")
else:
    strlabels = str("#website=" + sitename + ":")

# Open a UDP socket to send messages

sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

# Start the test loop

while True:
    try:
        start = datetime.datetime.now() # pick start time
        r = requests.get(url, timeout=6) # launch the test, max 6 sec allowed
        stop = datetime.datetime.now() # pick time at the end of the request
        elapsed = stop - start # difference
        currDate = datetime.datetime.now()
        currDate = str(currDate.strftime("%d-%m-%Y %H:%M:%S"))
        respTime = str(round(elapsed.total_seconds()*1000,2))
    except requests.exceptions.HTTPError as err01:
        print ("HTTP error: ", err01)
    except requests.exceptions.ConnectionError as err02:
        print ("Error connecting: ", err02)
    except requests.exceptions.Timeout as err03:
        print ("Timeout error:", err03)
    except requests.exceptions.RequestException as err04:
        print ("Error: ", err04)

    # Print the result to STDIN

    statdMessage = name + strlabels + respTime + "|g"
    print( statdMessage )

    # Write to statD
    
    sock.sendto(statdMessage.encode(), ("127.0.0.1", 8125))

    # example of statd output: echo "websiteResponseTime#website=www.google.com:10|g" > /dev/udp/127.0.0.1/8125
    
    time.sleep(interval) # Wait for the next text
