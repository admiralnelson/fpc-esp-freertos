# Simple HTTP server
This example demonstrates the following:
* Connect to a wifi access point.
* Configure a server instance.
* Configure URI handlers for __/__ and __/fpclogo.gif__. Accessing root will display a welcoome message and link to an embedded FPC logo.

## Notes
* Example adapted for both ESP32 and ESP8266.
* [FPC running logo](https://wiki.lazarus.freepascal.org/images/4/4f/fpc_running_logo.gif) complements of user Jwdietrich.
* Gif file converted to inline array of char using FPC's data2inc tool.
