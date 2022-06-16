Readme for DEP.X2
===============================================================================================

Step 1:	Download the zip file of the project from https://github.com/udayg2000/MyGateApp

Step 2: Extract the project zip file in the desired location and enter into the root folder.

Step 3: 
Commands to install requirements for Backend:
cd backend
pip install -r requirements.txt

Step 4:
Command to populate db (if empty)
cd backend\Project Data
python populate_db.py

Step 5:
Command to install requirements for Frontend:
flutter pub get

Step 6:
Commands to run the program:
python manage.py runserver
flutter run -d chrome --web-port 8080

To generate apk:
flutter build apk --build-name=1.0.1 --build-number=1

===============================================================================================