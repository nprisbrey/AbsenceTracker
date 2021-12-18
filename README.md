# AbsenceTracker

Demonstration of a digital way to track students leaving the classroom while class is in session.

## Usage

The app has three different configurations that the user can toggle: Student, Teacher, and Yard Supervisor. When implemented the user would be assigned one of these configurations according to their respective situation.

### Student:

<table>
  <tr>
    <td align="center"><p><b>Students can request at anytime to leave the classroom. The teacher authorizing the absence uses their app to scan the student's QR code.</b></p>
      <p>Right: Example of a student's QR code ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146614166-c40e29cd-3b5d-4d7e-bac1-4ea72a0fe954.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
  <tr>
    <td align="center"><p><b>Once scanned, an absence is registered online. The student can then show their QR code to Yard Supervisors while out of class and can say when they've returned to class.</b></p>
      <p>Right: Example of student's QR code after authorization ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146614237-70338ab8-e571-4c41-81c4-729052f9a9cc.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
</table>

### Teacher:

<table>
  <tr>
    <td align="center"><p><b>Teachers scan a student's QR code to authorize their absence at any time. After scanning the student's QR code, the teacher then enters how much time they authorize the student to be out of class. This time is also stored online.</b></p>
      <p>Right: Example of a teacher choosing how much time to give a student ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146614417-bb4ed102-0802-4ca3-89bf-5260febe3f16.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
  <tr>
    <td align="center"><p><b>Teachers also can view all of the students that they've authorized to leave class. Students that have been out for more than their permitted time are displayed in red while students that are still allowed to be out of class are displayed in green. If a student's QR code has been scanned by a yard supervisor, an exclamation mark is shown next to their name.</b></p>
      <p>Right: Example of the list of students authorized by a teacher ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146619193-136d2b28-80d1-46f3-abca-b2ac2d08ad08.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
  <tr>
    <td align="center"><p><b>From the display of students, teachers can choose at anytime to revoke any of the absences that they have authorized.</b></p>
      <p>Right: Example of the dialogue to revoke a student's pass ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146619248-b43791c7-050c-4720-a271-2be0a946c580.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
</table>

### Yard Supervisor:

<table>
  <tr>
    <td align="center"><p><b>Yard supervisors can scan the QR code of any student. Once scanned, the supervisor can see: if the pass is expired, the student's name, teacher that authorized the absence, when the pass was authorized, and for how long the pass is valid. The supervisor can invalidate the pass of the student if they wish the student to return to class.</b></p>
      <p>Right: Example of yard supervisor's view of a student's pass ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146619386-e8482006-b362-435a-9698-09661f89b4df.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
  <tr>
    <td align="center"><p><b>Yard supervisors have the ability to see ALL students that have been authorized to leave class. Like teachers, supervisors have students color-coded, can see if a student has been scanned by another yard supervisor, and can revoke any student's pass.</b></p>
      <p>Right: Example of list of all students out of class ---></p></td>
    <td align="center"><img src="https://user-images.githubusercontent.com/10404106/146619469-66f0818d-acc8-4816-9dd0-8bdd3a7bf468.png" alt="Screenshot Example" style="width:50%;"></td>
  </tr>
</table>

## Code

Most of the custom files can be found in the "[/lib](github.com/nprisbrey/AbsenceTracker/tree/master/lib)" directory.

This app was written using the Dart language with the Flutter framework. If you just want to install the app on your device, you can find the apk file at: "[/build/app/outputs/apk/app.apk](github.com/nprisbrey/AbsenceTracker/tree/master/build/app/outputs/apk/app.apk)".

If working or compiling this project, let it be noted that the file "android/gradle/wrapper/gradle-4.10.2-all.zip" was omitted due to its size but can be found [here](services.gradle.org/distributions/gradle-4.10.2-all.zip).
