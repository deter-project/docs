# Create Experiment

You can use the web interface to create a new experiment. 

1. Log into <a href="https://www.isi.deterlab.net">DETERLab</a> with your account credentials
2. Click the *Experimentation* menu item, then click *Begin an Experiment*.
3. Click *Select Project* and choose your project. Most people will be a member of just one project, and will not have a choice. If you are a member of multiple projects, be sure to select the correct project from the menu. In this example, we will refer to the project as *YourProject*.
4. Leave the *Group* field set to *Default Group* unless otherwise instructed.
5. Enter the *Name* field with an easily identifiable name for the experiment. The Name should be a single word (no spaces) identifier. If you are following our tutorial, use *basic-experiment* for the name.
6. Enter the *Description* field with a brief description of the experiment. Any string will work here.
7. In the **Your NS File** field, upload the *basic.ns* file you downloaded or any other NS file you created. You can also create the file on DETERLab by SSH-ing to *users.deterlab.net* and using a text editor like vi, vim, emacs, nano or pico. In that case you would specify the path to the file like */users/YourUsername/YourFilename.ns*.
     The rest of the settings depend on the goals of your experiment. In our example, please set the *Idle Swap* field to *1 h* and leave the rest of the settings for *Swapping*, *Linktest Option*, and *BatchMode* at their default.
8. Click *Submit*.  

After submission, DETERLab will begin processing your request. Since you did not check *Swap In Immediately* box, DETERLab will simply check sytax of your NS file and save some state in the database. You will receive an email and a pop-up notification when this has been done. The process usually takes a few seconds.

