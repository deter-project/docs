= Class Functionalities
[[TOC]]

Since we apply different access control (see [#ac about this topic]) for educational projects we really need to hear from you if you're planning to run a class on DeterLab. This is the procedure you should follow:

= Actions at the Start/End of a Class

== Start a class project

If you don't already have a project for the given class, start a new project on DeterLab by selecting Experimentation->Start New Project once you log into DeterLab or click [here](https://www.isi.deterlab.net/newproject.php). Tell us in the description that this is a class project. *Note:* Only do this if you have never taught a given class. For each new semester that you teach the same class recycle your current class project by following the guidelines outlined here.
If you already have a research project on DeterLab do not reuse your research project for your class. Start a new project and categorize it as "class" in the project application.
Wait for your project to be approved. It should take a few days and you should receive an automated email message once it is approved.

== [=#setup Set up your class] 

If you don't already have a class project see above.
In "My DeterLab" view, find the "Teaching" tab and click on your class. Then select Setup Class from the left menu. You will not be able to enroll students until you complete this step. You will be able to populate your class with materials.

You need to input the end date for your class, the estimated number of students and at least one anticipated assignment. For the assignment, make your best guess of the start and submission dates, and the number of machines you will need per student. You can change these values at any time. The system calculates the class limit automatically as _per_student''*''num_students_*0.25. You can also assign a value that is more suitable for your needs. At least one of the "number of machines per student" or "class limit" values must be entered. 

== Create accounts for students and TAs

DO NOT ask students or TAs to open accounts themselves. Follow the steps below.

If this is a repeat offering of the class make sure to recycle all accounts first. In "My DeterLab" view, find the "Teaching" tab and click on "Recycle Class". This will wipe all student accounts (not TA's), and all the assignments and submissions. Materials will remain in the class so you can reuse them in the current offering if you like. Please remember to change the visibility of materials manually (see  [#point1 how]}.

Accounts are created by copy/pasting your students' (or TA's) emails, one per line. Account creation takes up to a minute per student. When accounts are created, the system will automatically email the students/TAs so make sure to alert them to the fact that you are signing them up for a DeterLab account.

If your students or TAs later desire to use DeterLab for research they will need to join a research project, and open an individual account on DeterLab. Class accounts are only for class use. If you later desire to use DeterLab in research please apply for a research project.

== [=#wrapup Course Wrap-up]

=== Student account locking and removal

On the day that the end-of class is reached, all student accounts will be locked and email will be sent to the instructor appraising them of the action. This means that your students will no longer be able to log into DeterLab.

2 weeks after the class end date we will email the instructor reminding them that student accounts are about to be recycled. If the instructor wishes to delay this, they can update the end-of-class date. 4 weeks after the class end date, all student accounts will be wiped (files removed, email aliases removed, new SSL certificates generated).

=== Incompletes
The instructor can preserve accounts for students who were granted incomplete grades in the class by doing the following: In "My DeterLab" view, find the "Teaching" tab and click on "Manage students or TAs" from the left menu. Then select the students you want to grant incompletes for, and select "Grant Incomplete" from the drop box below the student list. 

A student account which is marked as being granted an incomplete will not be wiped. If the incomplete is granted before the end of class, the account will not be locked. If the incomplete is granted after the class ends but before it is is wiped, the account will be unlocked, but the student will need to set the password again in the manner they did at the beginning of the semester.

Once the student has completed the work the teacher should recycle the student's account (see  [#point2 how]).

== [=#handoff Course hand-off to another instructor]

Some classes at one institution get taught by different instructors each time. If you want to hand your class off to another instructor ask him to create the DeterLab account (at  [this link](https://www.isi.deterlab.net/joinproject.php)) and to join project Share. If he already has a DeterLab account skip this step. Then either you or him should file a ticket asking testbed ops to complete the hand-off. Please follow these steps even if a hand-off is temporary.

*Note:* these instructions do not apply to instructors from different institutions looking to adopt each other's material in a course they teach. For that, look at our guidelines for [wiki:Sharing sharing].

= [=#manage Managing a Class]

== [=#managestudents Students]

You and your TA both can manage your course with minimal involvement of DeterLab operations. You can create accounts for students and TAs, recycle accounts for the next semester, delete accounts for students who dropped the class, and follow student's usage of DeterLab. 

Additionally, you can do the following actions to help students that have problems during your class:

=== Reset student passwords 

A student may forget their password. From the left menu choose "Manage students or TAs". Select students that need help and choose "Reset password" from the select box below the student list. Students will receive an automated email about choosing a new password. 


=== Unfreeze student accounts

A student may make too many failed login attempts and their account will be automatically frozen. You can unfreeze it in the following manner. From the left menu choose "Manage students or TAs". Select students that need help and choose "Unfreeze Web access" from the select box below the student list. Students will receive an automated email about choosing a new password. 

=== Reset SSH keys

A student may mangle or delete their .ssh directory. This leads to failures when a student tries to swap in an experiment. The message they receive says "event system failed to start". You can regenerate their SSH keys it in the following manner. From the left menu choose "Manage students or TAs". Select students that need help and choose "Reset SSH keys" from the select box below the student list. Students will receive an automated email about choosing a new password. 

=== Login as a student the Web interface. 

From the left menu choose "Manage students or TAs" and click on the glasses icon next to the student.

=== [=#point6 Login into a student's experiment]

SSH to users.deterlab.net and then SSH to the student's experiment as a root, like this ssh root@node.exp.proj.
If you want to get a student's view you can type "sudo su student_username" once you perform the previous steps.

=== [=#point2 Recycle an account]

From the left menu choose "Manage students or TAs". Select students that you want to recycle and choose "Recycle" from the select box below the student list. This will wipe out the student's password and SSH keys, and all the items in the student's home directory.

== [=#managematerials Materials]

These functionalities are all exported via DeterLab Web interface ("My DeterLab" - tab "Teaching").

=== [=#point3 Adding new materials]

A material can be a useful link for your students, a required reading, a set of lecture slides, a homework assignment, etc. There are two ways to add a new material to your class. 

==== Adopting a shared material

See instructions about [wiki:Sharing sharing].

==== Uploading a material or specifying an URL

From the left menu choose "Add Materials to Class". For URLs, we only support those that start with "http". If your URL starts with https specify it with http instead - servers automatically rewrite these URLs to use https. For upload, we only support adding of ZIP files that are automatically unzipped after upload. You can zip and upload a single file (e.g., a Word document) or place many materials in a folder, create index.html to point to them and zip and upload the entire folder. 

Choose the closest type of the material from our selection menu. The visibility setting determines who can see the materials - only the instructor/TA or a group of students or all students.

=== Managing materials

Click on "Manage Materials" from the left menu. You can change [=#point1 visibility] of materials or delete them.

*Note:* Deleting a material also deletes all assignments based on this material and any submissions for these assignments. 


== [=#manageassignments Assignments]

These functionalities are all exported via DeterLab Web interface ("My DeterLab" - tab "Teaching").


=== Assign to Students

To assign something to students you must first add it to your class via [#point3 Add Materials]. Then choose "Assign to Students" from the left menu.

Select materials you want to assign from the list and choose if you want to assign them to all students, a group of students, or individual students. You must set the due date for the assignment and fill either the anticipated number of nodes per student or the class limit (see [#rl about class limits]). Once you create an assignment, the system will automatically enforce the limit for your class from the date of the assignment's creation until the due date. If you modify the due date ( see [#point5 how]) the system will automatically modify the limits.

=== [=#point5 Managing Assignments]

From the left menu choose "Manage Assignments". You can delete an assignment (select those you want to delete and click Modify),  change the due date (input a new date and click Modify), view student progress or download submissions for grading. You can download submissions many times, new submissions will be added to the folder with the old ones.

*Note:* Deleting an assignment also deletes all submissions for it. 

== [=#ac Access Control]

When an experiment is created in a DeterLab _research_ project by one member, *all* members have their home directories exported to the experiment's machines. All members can also log on to the experiment's machines. This creates problem for educational use of DeterLab since students can log on to experiments created by their classmates and can also access their home directories (if they change permissions on them first, running sudo from experimental machines). To address these problems we treat class projects differently than research projects.

If a student creates an experiment in the default group of the project, *only* this student (and no other students, TAs or instructors) gets his home directory exported to the experiment's machines. Instructors and TA's will be able to log on to the machines with root privileges (see [#point6 how]). No other students will be able to log on this experiment's machines. This creates conditions for class use of DeterLab by individual students.

If a student creates an experiment in a group other than default, *all* members of that group (and no other students, TAs or instructors) get their home directories exported to the experiment's machines, and can log on to them. Instructors and TA's will be able to log on to the machines with root privileges. This creates conditions for class use of DeterLab by groups of students. Content is protected between groups but collaboration is facilitated within each group.

In the past we have been asked by instructors to prevent topology display on the experiment's Web page so students could learn how to use reconnaissance tools to infer it. We are working on automating this process. At the moment, if you need this service file a ticket.

== [=#rl Resource Limits]

Once you set up your course and input a schedule of assignments an automated software will enforce the limits you set on your class. This means that if your limit is L for a given day your students will only be able to use up to L total machines at that day simultaneously. You can always change limits to accommodate more students by choosing "Setup Class" from the left menu. Please be mindful of other DeterLab users and set reasonable limits for your class. These are usually around 1/4 of the max anticipated usage for your class. 

When you create the Nth assignment for your students our system rewrites the Nth anticipated assignment in your class schedule with the actual assignment you created. If you end up moving a due date of your assignment, the limits will be extended to match the new due date. This way if you end up moving around your class assignments or changing what you want to do and how many machines will be in use, the limits will be adjusted automatically. 

Use of resources by students that are granted incompletes in your class is not counted against the class limit. Also use of resources by the teacher or the TAs is not counted against the class limit.

If a student attempts to swap in an experiment in your class on a day for which limits have not been set, and if this student does not have an incomplete, this swap in will fail and the student will receive a message that he/she was not allowed to allocate resources.
