# Table edumaterial_types
Purpose: store types of material we have
* type: encoded type
* description: textual description of type like slides, HTML lecture, homework, CCTF

# Table edumaterial_shared
Purpose: store all shared materials
* ID: unique ID
* type: encoded type
* access: student/teacher
* title
* location folder or binary content
* author contact: uid
 

# Table edumaterial_tags
* material ID from edumaterial_shared
* tag: enables searching 

# Table class_assignments
Purpose: Record what is assigned per class, allow for versioning of materials specific to class
* ID: unique ID
* title
* location folder or binary folder
* PID of the class that's adopting it (idx?)
* GID of the group that's assigned to (idx?)
* state: prepared/assigned/expired
* due_on: date when it is due
* after_due: show/hide

# Table student_assignments
Purpose: Record what is assigned per student, allow for submissions
* ID: unique ID
* assignment_ID: ID from class_assignments
* uid: uid from users
* state: submitted/not submitted
* submission_time: datetime
* submission: binary record or folder where submitted materials are 