
!!! note
    This page is updated to show the workflow with our <a href="https://launch.mod.deterlab.net/">new platform</a>.

# Course Setup

Since we apply different access control ([see about this topic](#access-control)) for educational projects, we really need to hear from you if you're planning to run a class on DETERLab. This is the procedure you should follow:

## Actions at the Start/End of a Class

### Start a class project

If you don't already have a project for the given class, start a new project on DETERLab by selecting _Experimentation->Start New Project_ once you log into DETERLab or [click here](https://www.isi.deterlab.net/newproject.php). Tell us in the description that this is a class project.

!!! note 
    Only do this if you have _never_ taught a given class. For each new semester that you teach for the same class, recycle your current class project (see [here](#recycle-an-account)). 
    
    If you already have a research project on DETERLab, do not reuse your research project for your class. Start a new project and categorize it as "class" in the project application. Wait for your project to be approved. It should take a few days and you should receive an automated email message once it is approved.


### Set up your class

If you don't already have a class project see above. 

1. Log in to DETERLab, click the _My DETERLab_ link, find the _Teaching_ tab and click on your class. 
2. Then select _Setup Class_ from the left menu. You will not be able to enroll students until you complete this step. You will be able to populate your class with materials.
3. Input the end date for your class and the estimated number of students
4. **In our new workflow** you must set up your Merge password in your user profile, so you and your students can use our new platform for experimentation. You will do this only once. Please see <a href="../../support/migration/index.html#migrating-class-projects">illustrations</a>. 
5. **In our new workflow** you must select _Migrate Class_ from the left menu to create your class on our new platform. You only need to do this once per class project.

### Create accounts for students and TAs

DO NOT ask students or TAs to open accounts themselves. Follow the steps below.

!!! note
    If this is a repeat offering of the class, make sure to recycle all accounts first (see [how](#recycle-an-account)). Materials will remain in the class so you can reuse them in the current offering if you like. Remember to change the visibility of materials manually (see how in [Manage materials](#managing-materials)).

To create accounts:

1. Copy and paste your students' (or TA's) emails, one per line. Account creation takes up to a minute per student. 
2. When accounts are created, the system will automatically email the students/TAs so make sure to alert them to the fact that you are signing them up for a DETERLab account. Students and TAs will get an automatically chosen username and password in email. 

!!! note  
    If you, your students or TAs later desire to use DETERLab for research, they will need to open a research account <a href="https://launch.mod.deterlab.net/">on our new platform</a>. **Class accounts are only for class use**. 

## Course Wrap-up

### Student account locking and removal

**On the day that the end-of class is reached:** All student accounts will be locked and instructors will be notified by email. _This means that your students will no longer be able to log into DETERLab._

**Two weeks after the class end date:** We will email the instructor reminding them that student accounts are about to be recycled. If the instructor wishes to delay this, they can update the end-of-class date. 

**Four weeks after the class end date:** All student accounts will be wiped (files removed, email aliases removed, new SSL certificates generated).

### Incompletes

The instructor can preserve accounts for students who were granted incomplete grades in the class by doing the following: 

1. In _My DETERLab_ view, find the _Teaching_ tab and click on _Manage students or TAs_ from the left menu. 
2. Select the students you want to grant "incompletes" for.
3. Select _Grant Incomplete_ from the drop box below the student list. These accounts will not be wiped. 

!!! note
    If the incomplete is granted before the end of class, the account will not be locked. 
    
    If the incomplete is granted after the class ends but before it is is wiped, the account will be unlocked, but the student will need to set the password again in the manner they did at the beginning of the semester.

Once the student has completed the work the teacher should recycle the student's account ([see how](#recycle-an-account)).

## Course hand-off to another instructor

Some classes within the same institution may be taught by different instructors each time. To hand your class off to another instructor:

1. Create a TA account for the new instructor
2. Either you or the new instructor should [file a ticket](https://trac.deterlab.net/wiki/GettingHelp) asking Testbed Ops to complete the hand-off. 

**Please follow these steps even if a hand-off is temporary.**

!!! note 
    These instructions do not apply to instructors from _different_ institutions looking to adopt each other's material in a course they teach. For that, look at our [guidelines for sharing](../../core/sharing/).

## Managing a Class

### Students

You and your TA both can manage your course with minimal involvement of DETERLab operations. You can create accounts for students and TAs, recycle accounts for the next semester, delete accounts for students who dropped the class, and follow student's usage of DETERLab.

Additionally, you can do the following actions to help students that have problems during your class:

#### Lookup and reset student passwords

If a student forgets their password:

1. From the left menu choose _Manage students or TAs_. 
2. Look up student's password in the last column of the table.
3. If you wish you can select the student and choose _Reset password_ from the select box below the student list. 

The student will receive an automated email with their new password.

#### Unfreeze student accounts

If a student makes too many failed login attempts, their account will be automatically frozen. To unfreeze it:

1. From the left menu choose _Manage students or TAs_. 
2. Select the student and choose _Unfreeze Web access_ from the select box below the student list. 

The students will receive an automated email with instructions for choosing a new password.

#### Reset SSH keys

If a student mangles or deletes their `.ssh` directory, any attempt to swap in an experiment will fail with the error message "event system failed to start". 

To reset their SSH keys:

1. From the left menu choose _Manage students or TAs_. 
2. Select the student and choose _Reset SSH keys_ from the select box below the student list. 

Students will receive an automated email with further instructions.

#### Login as a student in the web interface

1. From the left menu choose _Manage students or TAs_
2. Click on the glasses icon next to the student.

#### Recycle an account

1. From the left menu choose _Manage students or TAs_. 
2. Select the appropriate students and choose _Recycle_ from the select box below the student list. 

!!! warning
    This will wipe out the student's password and SSH keys and all the items in the student's home directory.

### Materials

The following functions occur within DETERLab's web interface (go to _My DETERLab ->  Teaching_).

#### Adding new materials

A "material" is a useful link for your students, required reading, a set of lecture slides, a homework assignment, etc. There are two ways to add a new material to your class.

##### 1\. Adopt a shared material

See instructions about [sharing](../../core/sharing/).

##### 2\. Upload a material or specify a URL

1. From the left menu choose _Add Materials to Class_ and follow the direction to upload a file or use a URL. 
2. For upload, we only support adding of ZIP files that are automatically unzipped after upload. You can zip and upload a single file (e.g., a Word document) or place many materials in a folder, create index.html to point to them and zip and upload the entire folder.
3. For URLs, we only support those that start with `http`. If your URL starts with `https`,  use `http` instead - servers automatically rewrite these URLs to use `https`. 
4. From the selection menu, choose the closest type of the material. 
5. The visibility setting determines who can see the materials: only the instructor/TA, a group of students or all students.

#### Managing materials

Click on _Manage Materials_ from the left menu. You can change visibility of materials or delete them.

!!! note 
    Deleting a material also deletes all assignments based on this material and any submissions for these assignments.

### Assignments

These functions occur within DETERLab's web interface (go to _My DETERLab ->  Teaching_).

#### Assign to Students

To assign something to students:

1. Add it to your class via _Add Materials_. 
2. Choose _Assign to Students_ from the left menu.
3. Select materials you want to assign from the list and choose if you want to assign them to all students, a group of students, or individual students. 
4. You must set the due date for the assignment.

#### Managing Assignments

To make changes to assignments:

1. From the left menu choose _Manage Assignments_. 
2. To delete an assignment, select those you want to delete and click _Modify_ (see warning below).
3. To change the due date, input a new date and click _Modify_. If you modify the due date, the system will automatically modify the limits for your class.

!!! warning 
    Deleting an assignment also deletes all submissions for it.

#### Monitoring progress

You can monitor progress on an assignment by clicking on *Teaching* tab, then *Manage Assignments* on left sidebar, then *View progress* button next to the given assignment. You will be able to see which students have started work, and which have submitted their answers.

#### Downloading submissions

To download student submissions click on *Teaching* tab, then *Manage Assignments* on left sidebar, then *Download submissions* button next to the given assignment. 

You can download submissions many times. New submissions will be added to the folder with the old ones.

### Access Control

Students do not have access to each other's files or experiments. Currently teachers and TAs can access students' experiments using username and password for a student (shown in _Manage Students or TAs_ view).


