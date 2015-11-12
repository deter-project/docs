
[[TOC]]

# Updating Your JVM (Java Virtual Machine) To The Latest Release
* If you already have an up-to-date version of the JVM, you can skip this section.
* Navigate to http://www.java.com/en/download/
* Follow the instructions on the Java website to update your JVM.

# Adding A Java Exception For The Java GUI
Due to the security risks involved with running Java applets, all Java applets are blocked by the JVM (Java Virtual Machine) by default. In order to use the Java GUI for creating .NS files, an exception for the applet must be created:

* Open up your Java Control Panel (e.g. C:/Program Files(x86)/Java/jrex.x.x_x/javacpl.exe).
* Click on the "Security" tab.
* Click on the "Edit Site List..." button at the bottom of the window.
* In the pop-up window, click the "Add" button and type the url of the applet (https://www.isi.deterlab.net).
* Once you are done entering the exception address, click the "OK" button.

# Internet Explorer: Unblocking Java applets for the DeterLab website
* Open up Internet Explorer and click on the gear icon near the top right portion of the window.
* Click on "Internet Options" from the dropdown.
* Now click on the "Security" tab in the new pop-up window.
* Click on the "Trusted Sites" icon (with the green check mark). This should cause the "Sites" button to be enabled.
* Once the "Sites" button is enabled, click on it.
* In the pop-up window, type https://www.isi.deterlab.net in the text box and click the "Add" button.
* Close the "Trusted Sites" exceptions window.
* Back in the "Internet Options" window, click the "Custom Level..." button.
* Scroll down near the bottom of the list and make sure "Scripting of Java Applets" is enabled.
* Click the "OK" button.
* Back in the "Internet Options" window click the "Apply" button and exit out of the window.
* Close your Internet Explorer browser to make sure all the changes you just made take effect.
* Open the browser again and navigate to the the GUI applet (https://www.isi.deterlab.net/clientui.php3).
* The Java GUI may take about five minutes to load.

# Google Chrome: Using the IE Tab extension for NPAPI support
Google Chrome has gradually been removing support for NPAPI (Netscape Plugin Application Programming Interface) for security reasons. Since Java applets rely on NPAPI to function, Google Chrome is no longer compatible with Java applets. Fortunately, there is a work around via Chrome extensions:

* Go to the Google Chrome webstore (https://chrome.google.com/webstore).
* Search for the IE Tab extension in the search box provided.
* Click on the "Extensions" tab under the search box to narrow the search results.
* Click on the IE Tab extension offered by ietab.net (the extension offered by ProDev has not been tested with the Java GUI).
* Install the IE Tab extension for Chrome by clicking on the "Add To Chrome" button.
* Once the installation is complete, a new IE Tab icon will appear to the right of your Google Chrome address bar.
* Click on the IE Tab icon to open a new Internet Explorer tab.
* Navigate to the Java GUI inside the IE tab (https://www.isi.deterlab.net/clientui.php3).
* You may encounter a pop-up window asking if you want to run the application.
* Click on the “Run” button to allow the Java GUI to run.
* The Java GUI may take about five minutes to load.