# from .models import Student
# from .serializers import StudentSerializer
# Import all the models and serializers
import os
from unicodedata import category
from .models import *
from .serializers import *
from rest_framework.generics import ListAPIView
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.permissions import IsAdminUser
from django.contrib.auth.models import User
import json
from django.contrib.auth.hashers import *
from datetime import date, datetime
import csv
from django.core.mail import send_mail
import random
from django.conf import settings
from datetime import datetime
from django.core.files.base import ContentFile
from .thread import *
# Password storing work
# encrypted = make_password("Vasu")
# check_password("Vasu", encrypted)

initial_data = 'initial_data'
blank_value = "None"
THREAD_ACTIVATED = False

# @api_view(['GET', 'POST'])
# def thread_functions(request):
#     try:
#         global THREAD_ACTIVATED
#         if THREAD_ACTIVATED == False:
#             THREAD_ACTIVATED = True
#             AutomaticExitThread().start()
#         return Response(status = status.HTTP_200_OK)
#     except:
#         return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)
    
@api_view(['GET', 'POST'])
def init_db(request):    
    Department.objects.create(
        dept_name = initial_data,
    )
    
    Program.objects.create(
        degree_name = initial_data,
        degree_duration = 0,        
    )
    
    Hostel.objects.create(
        hostel_name = initial_data,
    )  
    
    Location.objects.create(
        location_name = initial_data,
    )  
    
    Authorities.objects.create(
        authority_name = initial_data,
        authority_designation = initial_data,
        email = initial_data,
    ) 

    Student.objects.create(
        st_name = initial_data,
        entry_no = initial_data,
        email = initial_data,
        gender = initial_data,
        dept_id = Department.objects.get(dept_name = initial_data),
        degree_id = Program.objects.get(degree_name = initial_data),
        hostel_id = Hostel.objects.get(hostel_name = initial_data),
        room_no = initial_data,
    ) 
    
    AuthoritiesTicketTable.objects.create(
        auth_id = Authorities.objects.get(authority_name = initial_data),
        entry_no = Student.objects.get(entry_no = initial_data), 
        # date_time = date.today().strftime("%d/%m/%Y"),
        location_id = Location.objects.get(location_name = initial_data),
        ticket_type = initial_data, 
        authority_message = initial_data, 
        is_approved = initial_data, 
    ) 
    
    #  to add dummy foreign key in TicketTable use this query
    # ref_id = AuthoritiesTicketTable.objects.get(authority_message = initial_data)
    
    return Response(status = status.HTTP_200_OK)
    
@api_view(['GET', 'POST'])    
def clear_db(request):
    StatusTable.objects.all().delete()
    TicketTable.objects.all().delete()
    AuthoritiesTicketTable.objects.all().delete()
    Authorities.objects.all().delete()
    Student.objects.all().delete()
    Guard.objects.all().delete()
    Location.objects.all().delete()
    Hostel.objects.all().delete()
    Program.objects.all().delete()
    Department.objects.all().delete()
    Person.objects.all().delete()
    Password.objects.all().delete()
    Admin.objects.all().delete()
    OTP.objects.all().delete()    
    return Response(status = status.HTTP_200_OK)    

@api_view(['POST'])
def login_user(request):
    data = request.data
    try:        
        email = data['email']
        
        password = data['password']              
        queryset_password = Password.objects.get(email = email)
        serializer_password  = PasswordSerializer(queryset_password, many=False)
        encrypted_password = serializer_password.data['password']
        
        queryset_person = Person.objects.filter(email = email, is_present=True)
        serializer_person = PersonSerializer(queryset_person, many = True)
        person_not_present = len(queryset_person)==0
        
        
        if person_not_present:
            res = {
                "message" : "Invalid Email",
                "person_type": "NA",
            }
            print("User not Found")
            return Response(res, status= status.HTTP_200_OK)

        person_type = serializer_person.data[0]['person_type']
        
        if check_password(password, encrypted_password):
            res = {
                "message" : "Login Successful",
                "person_type": person_type,
            }
            print("Password Matched")
            return Response(res, status= status.HTTP_200_OK)
        
        else:
            res = {
                "message" : "Invalid Password",
                "person_type": "NA"
            }
            print("Password Different")
            return Response(res, status= status.HTTP_200_OK)
        
    except Exception as e:
        print("Exception in login user")
        print(e)
        res = {
                "message" : "Error: An error occured while logging in",
                "person_type": "NA"
            }
        
        return Response(res, status = status.HTTP_500_INTERNAL_SERVER_ERROR)
    
@api_view(['POST'])
def forgot_password(request):
    data = request.data
    try:             
        email = data['email']
        
        op = int(data['op'])
        
        # print("op")
        # print(type(op))
        # print(op)
        
        if op == 1:
            # print("value of op is 1")      
              
            is_not_present = len(Person.objects.filter(email = email)) == 0
            
            if is_not_present:
                response_str = 'User email not found in database' 
                res = {
                    "message" : response_str,
                }
                print(response_str)
                return Response(res, status = status.HTTP_200_OK)
            
            subject = 'Your Account verification OTP for MyGateApp is ...'
            
            otp = random.randint(100000,999999)
            
            message = f'Your OTP is {otp}'
            
            email_from = settings.EMAIL_HOST
            
            send_mail(subject, message, email_from, [email])
            
            print("email sent")
            
            is_not_present = len(OTP.objects.filter(email = email)) == 0
            if is_not_present:
                OTP.objects.create(email = email, otp = otp)        
            else:        
                OTP.objects.filter(email = email).update(otp = otp)
            
            response_str = 'OTP sent to email' 
            res = {
                "message" : response_str,
            }
            print(response_str)
            return Response(res, status = status.HTTP_200_OK)
        
        elif op == 2:
            queryset_otp = OTP.objects.get(email=email)
            
            serializer_otp = OTPSerializer(queryset_otp, many=False)
            
            db_otp = serializer_otp.data['otp']
            
            entered_otp = int(data['entered_otp'])
            
            # print("entered_otp")
            # print(entered_otp)
            
            if entered_otp == db_otp:
                response_str = 'OTP Matched' 
                res = {
                    "message" : response_str,
                }
                print(response_str)
                OTP.objects.filter(email=email).update(otp = -1)
                return Response(res, status = status.HTTP_200_OK)
            else:
                response_str = 'OTP Did not Match' 
                res = {
                    "message" : response_str,
                }
                print(response_str)
                return Response(res, status = status.HTTP_200_OK)
        
    except Exception as e:
        print(e)
        response_str = 'Exception in forgot password' 
        res = {
            "message" : response_str,
        }
        print(response_str)
        return Response(response_str, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def reset_password(request):
    try:             
        data = request.data
        
        email = data['email']
        
        password = data['password']
        
        Password.objects.filter(email = email).update(password = make_password(password))
        
        response_str = 'Password RESET Successful' 
        
        res = {
            "message" : response_str,
        }
        
        return Response(res, status = status.HTTP_200_OK)
        
    except Exception as e:
        response_str = 'Password RESET Failed' 
        
        print('Exception in reset_password: ' + str(e))
        
        res = {
            "message" : response_str,
        }
        
        return Response(response_str, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

########################################################## Adding data from file
""" 
Note: send the file as a form-data file with attribute name as 'file' in postman
"""
@api_view(['POST'])    
def add_departments_from_file(request):
    upFile = request.FILES.get('file')
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_department = data[i]
        if(len(curr_department)):
            is_department_present = len(Department.objects.filter(dept_name = curr_department[0]))!=0
            if is_department_present:
                Department.objects.filter(dept_name = curr_department[0]).update(is_present=True)
            else:
                Department.objects.create(
                    dept_name = curr_department[0]
                ) 
    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def add_programs_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_program = data[i]
        if(len(curr_program)):
            is_program_present = len(Program.objects.filter(degree_name = curr_program[0])) !=0
            if is_program_present:
                Program.objects.filter(degree_name = curr_program[0]).update(
                    degree_duration = curr_program[1],
                    is_present=True
                )
            else:
                Program.objects.create(
                    degree_name = curr_program[0],
                    degree_duration = curr_program[1]
                ) 
    
    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def add_hostels_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_hostel = data[i]
        if(len(curr_hostel)):
            is_hostel_present = len(Hostel.objects.filter(hostel_name = curr_hostel[0]))!=0
            if is_hostel_present:
                Hostel.objects.filter(hostel_name = curr_hostel[0]).update(is_present=True)
            else:
                Hostel.objects.create(
                    hostel_name = curr_hostel[0]
                ) 

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def add_locations_from_file(request):
    try:
        upFile = request.FILES.get("file")
        context = {}
        if upFile.multiple_chunks():
            context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
            return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
        else:
            context["uploadedFile"] = upFile.read()
        file_data = context["uploadedFile"].decode("UTF-8")
        file_data_list = file_data.split("\r\n")
        csvreader = csv.reader(file_data_list)
        data = list(csvreader)

        for i in range(1, len(data)):
            curr_location = data[i]
            if(len(curr_location)):
                location_already_exists = len(Location.objects.filter(location_name = curr_location[0])) != 0
                
                _pre_approval_required = True
                if curr_location[2] ==  "No":
                    _pre_approval_required= False

                _automatic_exit_required = True
                if curr_location[3] ==  "No":
                    _automatic_exit_required= False

                _parent_id = -1
                if curr_location[1]!= "None":
                    try:
                        queryset_location_table = Location.objects.get(location_name = curr_location[1])
                        location_serializer = LocationSerializer(queryset_location_table, many=False)
                        _parent_id = location_serializer.data['location_id']
                    except:
                        pass

                if location_already_exists:
                    Location.objects.filter(location_name = curr_location[0]).update(            
                        parent_id = _parent_id,
                        pre_approval_required = _pre_approval_required,
                        automatic_exit_required = _automatic_exit_required, 
                        is_present = True,         
                    )
                else:     
                    Location.objects.create(
                        location_name = curr_location[0],
                        parent_id = _parent_id,
                        pre_approval_required = _pre_approval_required,
                        automatic_exit_required = _automatic_exit_required, 
                        is_present = True,          
                    )
                
                # For this location, mark the status of all the students in the student table as out

                queryset_student = Student.objects.all()
                queryset_location_table = Location.objects.get(location_name = curr_location[0])

                for each_queryset_student in queryset_student:
                    serializer = StudentSerializer(each_queryset_student, many=False)
                    entry_no = serializer.data['entry_no']
                    
                    # If it is not a dummy student
                    if (entry_no != initial_data):
                        query_set_location_curr = Location.objects.get(location_name = curr_location[0])

                        status_table_entry_not_present = len(StatusTable.objects.filter(
                            location_id = query_set_location_curr,
                            entry_no = each_queryset_student)) == 0
                        
                        if status_table_entry_not_present:
                            StatusTable.objects.create(
                                entry_no = each_queryset_student,
                                location_id = queryset_location_table,    
                                current_status = 'out',        
                            )
                        else:
                            StatusTable.objects.filter(
                                location_id = query_set_location_curr,
                                entry_no = each_queryset_student).update(is_present=True,current_status = 'out')

            
        return Response(status=status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception in add_locations_from_file: " + e)
        return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

@api_view(['POST'])    
def add_authorities_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_authority = data[i]
        if(len(curr_authority)):
            # checking for all the three parameters as two authority can have same name, authority can get promoted, and hence his/her email will be changed in that case
            authority_not_present = len(Authorities.objects.filter(email = curr_authority[2]))==0
            if authority_not_present:
                Authorities.objects.create(
                    authority_name = curr_authority[0],
                    authority_designation = curr_authority[1],
                    email = curr_authority[2]
                )
            else:
                Authorities.objects.filter(email = curr_authority[2]).update(
                    authority_name = curr_authority[0],
                    authority_designation = curr_authority[1],
                    is_present=True
                )

            person_not_present = len(Person.objects.filter(email=curr_authority[2], person_type = "Authority"))==0
            if person_not_present:
                Person.objects.create(
                        email = curr_authority[2],
                        person_type = "Authority"
                    )
            else:
                Person.objects.filter(email=curr_authority[2], person_type = "Authority").update(is_present=True)
            
            password_not_present = len(Password.objects.filter(email=curr_authority[2]))==0
            if password_not_present:
                Password.objects.create(
                    email = curr_authority[2]
                )
            else:
                Password.objects.filter(email=curr_authority[2]).update(is_present=True)

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def add_guards_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_guard = data[i]
        if(len(curr_guard)):
            guard_not_present = len(Guard.objects.filter(email = curr_guard[2]))==0
            if guard_not_present:
                Guard.objects.create(
                    guard_name = curr_guard[0],
                    location_id =  Location.objects.get(location_name = curr_guard[1]),
                    email = curr_guard[2]
                ) 
            else:
                query_set_location_table = Location.objects.get(location_name = curr_guard[1])
                query_set_location_table_serializer = LocationSerializer(query_set_location_table,many=False)
                _location_id = query_set_location_table_serializer.data['location_id']
                Guard.objects.filter(email= curr_guard[2]).update(
                    guard_name = curr_guard[0],
                    location_id = _location_id,
                    is_present=True
                )
            person_not_present = len(Person.objects.filter(email=curr_guard[2], person_type = "Guard"))==0
            if person_not_present:
                Person.objects.create(
                        email = curr_guard[2],
                        person_type = "Guard"
                    )
            else:
                Person.objects.filter(email=curr_guard[2], person_type = "Guard").update(is_present=True)

            password_not_present = len(Password.objects.filter(email=curr_guard[2]))==0
            if password_not_present:
                Password.objects.create(
                    email = curr_guard[2]
                )
            else:
                Password.objects.filter(email=curr_guard[2]).update(is_present=True)

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def add_students_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_student = data[i]
        # print(curr_student, len(curr_student))
        if(len(curr_student)):
            is_student_present = len(Student.objects.filter(entry_no = curr_student[1]))!=0
            if is_student_present:
                Student.objects.filter(entry_no =  curr_student[1]).update(
                    st_name = curr_student[0],
                    entry_no = curr_student[1],
                    email = curr_student[2],
                    gender = curr_student[3],
                    dept_id = Department.objects.get(dept_name = curr_student[4]),
                    degree_id = Program.objects.get(degree_name = curr_student[5]),
                    hostel_id = Hostel.objects.get(hostel_name = curr_student[6]),
                    room_no = curr_student[7],
                    year_of_entry = curr_student[8],
                    is_present=True
                )
            else:
                Student.objects.create(
                    st_name = curr_student[0],
                    entry_no = curr_student[1],
                    email = curr_student[2],
                    gender = curr_student[3],
                    dept_id = Department.objects.get(dept_name = curr_student[4]),
                    degree_id = Program.objects.get(degree_name = curr_student[5]),
                    hostel_id = Hostel.objects.get(hostel_name = curr_student[6]),
                    room_no = curr_student[7],
                    year_of_entry = curr_student[8],
                ) 
                
                # update the status table accordingly
                queryset_location_table = Location.objects.all()
                queryset_entry_no = Student.objects.get(entry_no = curr_student[1])

                for each_queryset_location_table in queryset_location_table:
                    queryset_location_table_serializer = LocationSerializer(each_queryset_location_table, many=False)
                    queryset_location_table_location_name = queryset_location_table_serializer.data['location_name']
                    if( queryset_location_table_location_name != initial_data):
                        queryset_status_table = StatusTable.objects.create(
                            entry_no = queryset_entry_no,
                            location_id = each_queryset_location_table,            
                        )
            
            person_not_present = len(Person.objects.filter(email=curr_student[2], person_type = "Student"))==0
            if person_not_present:
                Person.objects.create(
                        email = curr_student[2],
                        person_type = "Student"
                    )
            else:
                Person.objects.filter(email=curr_student[2], person_type = "Student").update(is_present=True)
            
            password_not_present = len(Password.objects.filter(email=curr_student[2]))==0
            if password_not_present:
                Password.objects.create(
                    email = curr_student[2]
                )
            else:
                Password.objects.filter(email=curr_student[2]).update(is_present=True)

    return Response(status=status.HTTP_200_OK)

########################################################## Deleting data from file
@api_view(['POST'])    
def delete_departments_from_file(request):
    upFile = request.FILES.get('file')
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_department = data[i]
        if(len(curr_department)):
            Department.objects.filter(dept_name = curr_department[0]).update(is_present=False)

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def delete_programs_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_program = data[i]
        if(len(curr_program)):
            Program.objects.filter(degree_name = curr_program[0], degree_duration= curr_program[1]).update(is_present=False)
    
    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def delete_hostels_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_hostel = data[i]
        if(len(curr_hostel)):
            Hostel.objects.filter(hostel_name = curr_hostel[0]).update(is_present=False)

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def delete_locations_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)

    for i in range(1, len(data)):
        curr_location = data[i]
        if(len(curr_location)):
            
            _pre_approval_required = True
            if curr_location[2] ==  "No":
                _pre_approval_required= False

            _automatic_exit_required = True
            if curr_location[3] ==  "No":
                _automatic_exit_required= False

            _parent_id = -1
            if curr_location[1]!= "None":
                queryset_location_table = Location.objects.get(location_name = curr_location[1])
                location_serializer = LocationSerializer(queryset_location_table, many=False)
                _parent_id = location_serializer.data['location_id']

            Location.objects.filter(
                location_name = curr_location[0],parent_id = _parent_id,
                pre_approval_required = _pre_approval_required,
                automatic_exit_required = _automatic_exit_required).update(is_present = False)

            queryset_location_table = Location.objects.get(location_name = curr_location[0])
            StatusTable.objects.filter(location_id = queryset_location_table).update(is_present=False)

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def delete_authorities_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_authority = data[i]
        if(len(curr_authority)):
            # checking for all the three parameters as two authority can have same name, authority can get promoted, and hence his/her email will be changed in that case
            Authorities.objects.filter(email = curr_authority[2]).update(is_present=False)
            Person.objects.filter(email=curr_authority[2], person_type = "Authority").update(is_present=False)
            Password.objects.filter(email=curr_authority[2]).update(is_present=False)
            
    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def delete_guards_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_guard = data[i]
        if(len(curr_guard)):
            Guard.objects.filter(email= curr_guard[2]).update(is_present=False)
            Person.objects.filter(email=curr_guard[2], person_type = "Guard").update(is_present=False)
            Password.objects.filter(email=curr_guard[2]).update(is_present=False)

    return Response(status=status.HTTP_200_OK)

@api_view(['POST'])    
def delete_students_from_file(request):
    upFile = request.FILES.get("file")
    context = {}
    if upFile.multiple_chunks():
        context["uploadError"] = "Uploaded file is too big (%.2f MB)." % (upFile.size,)
        return Response(context['uploadError'], status= status.HTTP_500_INTERNAL_SERVER_ERROR)
    else:
        context["uploadedFile"] = upFile.read()
    file_data = context["uploadedFile"].decode("UTF-8")
    file_data_list = file_data.split("\r\n")
    csvreader = csv.reader(file_data_list)
    data = list(csvreader)
    for i in range(1, len(data)):
        curr_student = data[i]
        # print(curr_student, len(curr_student))
        if(len(curr_student)):
            is_student_present = len(Student.objects.filter(entry_no = curr_student[1]))!=0
            if is_student_present:
                Student.objects.filter(entry_no =  curr_student[1]).update(is_present=False)
                StatusTable.objects.filter(entry_no = curr_student[1]).update(is_present=False)
                Person.objects.filter(email=curr_student[2], person_type = "Student").update(is_present=False)
                Password.objects.filter(email=curr_student[2]).update(is_present=False)

    return Response(status=status.HTTP_200_OK)


############################### add data using form
@api_view(['POST'])
def add_guard_form(request):
    data = request.data
    
    try:
        _name = data['name']
        _email = data['email']
        _location_name = data['location_name']
        
        query_set_location =Location.objects.get(location_name = _location_name)
        _location_id = LocationSerializer(query_set_location).data['location_id']

        is_guard_present = len(Guard.objects.filter(email = _email))!=0
        if is_guard_present:
            #check the is_present attribute of the guard
            query_set_guard = Guard.objects.get(email = _email)
            serializer = GuardSerializer(query_set_guard,many=False)
            is_present = serializer.data['is_present']
            if is_present:
                response_str = "A Guard Already Exists with this email id"
                return Response(response_str, status.HTTP_200_OK)
            else:
                Guard.objects.filter(email = _email).update(
                    guard_name = _name,
                    email = _email,
                    location_id = _location_id,
                    is_present=True
                )
                
                Person.objects.filter(email = _email).update(is_present=True)
                Password.objects.filter(email= _email).update(is_present = True)
                response_str = "Guard Created Sucessfully"
                return Response(response_str, status.HTTP_200_OK)
        else:
            Guard.objects.create(
                guard_name = _name,
                location_id = query_set_location,
                email = _email
            )
            Person.objects.create(
                email = _email,
                person_type = "Guard"
            )
            Password.objects.create(email=_email)
            response_str = "Guard Created Sucessfully"
            return Response(response_str, status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception raised in add_guard_form function")
        print("The exception is " + str(e))
        response_str = "Error in creating guard"
        return Response(response_str, status.HTTP_500_INTERNAL_SERVER_ERROR)
        

@api_view(['POST'])
def add_admin_form(request):
    data = request.data
    
    try:
        admin_name = data['name']
        
        email = data['email']
        
        Admin.objects.create(email = email, admin_name = admin_name)
        
        Person.objects.create(email = email, person_type = 'Admin')
        
        Password.objects.create(email = email)
        
        response_str = "Admin created successfully"
        
        res = {
            "message" : response_str
        }
        
        return Response(res, status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception raised in add_admin_form function")
        
        print("The exception is " + e)
        
        response_str = "Error in creating admin"
        
        res = {
            "message" : response_str
        }
        return Response(res, status.HTTP_500_INTERNAL_SERVER_ERROR)

############################## modify data using form
@api_view(['POST'])
def modify_guard_form(request):
    data = request.data
    # _name = data['name']
    _email = data['email']
    _location_name = data['location_name']
    
    query_set_location =Location.objects.get(location_name = _location_name)
    _location_id = LocationSerializer(query_set_location).data['location_id']

    is_guard_present = len(Guard.objects.filter(email = _email, is_present=True))!=0
    if is_guard_present:
        Guard.objects.filter(email = _email).update(
            location_id = _location_id,
            is_present=True
        )
        
        Person.objects.filter(email = _email).update(is_present=True)
        Password.objects.filter(email= _email).update(is_present = True)

        response_str = "Guard updated sucessfully"
        return Response(response_str, status.HTTP_200_OK)
        
    response_str = "No guard exists with this email id"
    return Response(response_str, status.HTTP_200_OK)

################################ delete data using  form
@api_view(['POST'])
def delete_guard_form(request):
    data = request.data
    # _name = data['name']
    _email = data['email']
    
    is_guard_present = len(Guard.objects.filter(email = _email, is_present=True))!=0
    if is_guard_present:
        Guard.objects.filter(email = _email).update(is_present=False)
        Person.objects.filter(email = _email).update(is_present=False)
        Password.objects.filter(email= _email).update(is_present = False)

        response_str = "Guard Deleted sucessfully"
        return Response(response_str, status.HTTP_200_OK)
        
    response_str = "No guard exists with this email id"
    return Response(response_str, status.HTTP_200_OK)

################################ statistics 
check_status = "out"
@api_view(['POST'])
def get_statistics_data_by_location(request):
    data = request.data
    _location_name = data['location']
    _filter = data['filter']
    print("Location Name: " + _location_name)
    if _filter == "Gender":
        category_list= {}

        query_set_status_table = StatusTable.objects.filter(location_id = Location.objects.get(location_name=_location_name), current_status = check_status, is_present=True)
        for each_query_set in query_set_status_table:
            serializer = StatusTableSerializer(each_query_set, many=False)
            entry_no = serializer.data['entry_no']
            # now I need to find out their gender
            is_student_present = len(Student.objects.filter(entry_no = entry_no, is_present=True))!=0
            if is_student_present:
                student = Student.objects.get(entry_no = entry_no, is_present=True)
                student_serializer = StudentSerializer(student, many=False)
                gender = student_serializer.data['gender']
                # print("Student Name: " + student_serializer.data['st_name'])
                if gender in category_list:
                    category_list[gender]+=1
                else:
                    category_list[gender]=1
                    
        res=[]
        for key in category_list:
            StatisticsResultObj = {"category": key, "count": category_list[key]}
            res.append(StatisticsResultObj)
        
        return Response({"output": res}, status.HTTP_200_OK)

    elif _filter == "Department":
        # first retrieve the list of departments
        total_departments = len(Department.objects.filter(is_present=True))
        category_list ={}
        if total_departments==0:
            res=[]
            return Response({"output":res}, status.HTTP_200_OK)
        else:
            departments_query_set= Department.objects.filter(is_present=True)
            
            for each_department_query_set in departments_query_set:
                department_serializer = DepartmentSerializer(each_department_query_set, many=False)
                dept_name = department_serializer.data['dept_name']
                if dept_name != initial_data:
                    category_list[dept_name] =0

            query_set_status_table = StatusTable.objects.filter(location_id = Location.objects.get(location_name=_location_name), current_status = check_status, is_present=True)
            for each_query_set in query_set_status_table:
                serializer = StatusTableSerializer(each_query_set, many=False)
                entry_no = serializer.data['entry_no']
                # now I need to find out their gender
                is_student_present = len(Student.objects.filter(entry_no = entry_no, is_present=True))!=0
                if is_student_present:
                    student = Student.objects.get(entry_no = entry_no, is_present=True)
                    student_serializer = StudentSerializer(student, many=False)
                    dept_id = student_serializer.data['dept_id']
                    
                    department_not_present = len(Department.objects.filter(dept_id = dept_id, is_present=True))==0
                    if department_not_present:
                        res=[]
                        print("Department not present")
                        return Response({"output":res}, status.HTTP_200_OK)
                    else:
                        # get name of the department
                        department_query_set = Department.objects.get(dept_id = dept_id)
                        dept_name = DepartmentSerializer(department_query_set,many=False).data['dept_name']
                        # print("Student Name: " + student_serializer.data['st_name'])
                        # print("Department: " + str(dept_name))
                        category_list[dept_name]+=1
            res=[]
            for key in category_list:
                StatisticsResultObj = {"category": key, "count": category_list[key]}
                res.append(StatisticsResultObj)
            return Response({"output":res}, status.HTTP_200_OK)

    elif _filter == "Program":
        total_programs = len(Program.objects.filter(is_present=True))
        category_list ={}
        if total_programs==0:
            res=[]
            return Response({"output":res}, status.HTTP_200_OK)
        else:
            program_query_set= Program.objects.filter(is_present=True)
            
            for each_program_query_set in program_query_set:
                program_serializer = ProgramSerializer(each_program_query_set, many=False)
                degree_name = program_serializer.data['degree_name']
                if degree_name != initial_data:
                    category_list[degree_name] =0

            query_set_status_table = StatusTable.objects.filter(location_id = Location.objects.get(location_name=_location_name), current_status = check_status, is_present=True)
            for each_query_set in query_set_status_table:
                serializer = StatusTableSerializer(each_query_set, many=False)
                entry_no = serializer.data['entry_no']
                # now I need to find out their gender
                is_student_present = len(Student.objects.filter(entry_no = entry_no, is_present=True))!=0
                if is_student_present:
                    student = Student.objects.get(entry_no = entry_no, is_present=True)
                    student_serializer = StudentSerializer(student, many=False)
                    degree_id = student_serializer.data['degree_id']
                    
                    Program_not_present = len(Program.objects.filter(degree_id = degree_id, is_present=True))==0
                    if Program_not_present:
                        res=[]
                        print("Program not present")
                        return Response({"output":res}, status.HTTP_200_OK)
                    else:
                        # get name of the department
                        Program_query_set = Program.objects.get(degree_id = degree_id)
                        degree_name = ProgramSerializer(Program_query_set,many=False).data['degree_name']
                        # print("Student Name: " + student_serializer.data['st_name'])
                        # print("Program: " + str(degree_name))
                        category_list[degree_name]+=1
            res=[]
            for key in category_list:
                StatisticsResultObj = {"category": key, "count": category_list[key]}
                res.append(StatisticsResultObj)
            return Response({"output":res}, status.HTTP_200_OK)
    
    elif _filter == "Year":
        category_list={}
        query_set_status_table = StatusTable.objects.filter(location_id = Location.objects.get(location_name=_location_name), current_status = check_status, is_present=True)
        for each_query_set in query_set_status_table:
            serializer = StatusTableSerializer(each_query_set, many=False)
            entry_no = serializer.data['entry_no']
            # now I need to find out their gender
            is_student_present = len(Student.objects.filter(entry_no = entry_no, is_present=True))!=0
            if is_student_present:
                student = Student.objects.get(entry_no = entry_no, is_present=True)
                student_serializer = StudentSerializer(student, many=False)
                year_of_entry = str(student_serializer.data['year_of_entry'])
                
                print("Student Name: " + student_serializer.data['st_name'])
                print("Year of Entry: " + str(year_of_entry))
                if year_of_entry in category_list:
                    category_list[year_of_entry]+=1
                else:
                    category_list[year_of_entry]=1
        res=[]
        for key in category_list:
            StatisticsResultObj = {"category": key, "count": category_list[key]}
            res.append(StatisticsResultObj)
        return Response({"output":res}, status.HTTP_200_OK)

    return Response(status.HTTP_200_OK)

_ticket_type = "enter"
@api_view(['POST'])
def get_piechart_statistics_by_location(request):
    data = request.data
    _location_name = data['location']
    _filter = data['filter']
    _start_date = data['start_date']
    _end_date = data['end_date']
    category_list={}

    no_tickets = len(TicketTable.objects.filter(location_id = Location.objects.get(location_name = _location_name), ticket_type = _ticket_type, is_approved = "Approved"))==0
    if no_tickets:
        res=[]
        return Response({"output":res}, status.HTTP_200_OK)

    all_tickets = TicketTable.objects.filter(location_id = Location.objects.get(location_name = _location_name), ticket_type = _ticket_type, is_approved = "Approved")

    if _filter =="Hourly":
        for query_set in all_tickets:
            serializer = TicketTableSerializer(query_set,many=False)
            date_time = serializer.data['date_time']
            _date = date_time.split("T")[0]
            _time = (date_time.split("T")[-1]).split(".")[0]
            _hour = _time.split(":")[0]
            key = _hour+":00\n"+_date
            if _date<=_end_date and _date>= _start_date:
                if key in category_list:
                    category_list[key]+=1
                else:
                    category_list[key]=1
        res=[]
        for key in category_list:
            StatisticsResultObj = {"category": key, "count": category_list[key]}
            res.append(StatisticsResultObj)
        return Response({"output": res}, status.HTTP_200_OK)

    elif _filter == "Daily":
        for query_set in all_tickets:
            serializer = TicketTableSerializer(query_set,many=False)
            date_time = serializer.data['date_time']
            _date = date_time.split("T")[0]
            if _date<=_end_date and _date>= _start_date:
                if _date in category_list:
                    category_list[_date]+=1
                else:
                    category_list[_date]=1
        res=[]
        for key in category_list:
            StatisticsResultObj = {"category": key, "count": category_list[key]}
            res.append(StatisticsResultObj)

        return Response({"output": res}, status.HTTP_200_OK)

    
    elif _filter == "Monthly":
        for query_set in all_tickets:
            serializer = TicketTableSerializer(query_set,many=False)
            date_time = serializer.data['date_time']
            _date = date_time.split("T")[0]
            l= _date.split("-")
            _month = "-".join(l[:-1])
            if _date<=_end_date and _date>= _start_date:
                if _month in category_list:
                    category_list[_month]+=1
                else:
                    category_list[_month]=1
        res=[]
        for key in category_list:
            StatisticsResultObj = {"category": key, "count": category_list[key]}
            res.append(StatisticsResultObj)

        return Response({"output": res}, status.HTTP_200_OK)



    return Response(status.HTTP_200_OK)

########################################################################

@api_view(['GET'])
def get_students(request):
    queryset = Student.objects.all()
    serializer = StudentSerializer(queryset, many=True)
    return Response(serializer.data)

@api_view(['GET', 'POST'])
def get_all_students(request):
    res = []
    try:
        queryset = Student.objects.filter(is_present=True)
        
        serializer = StudentSerializer(queryset, many=True)
        
        for each_student in serializer.data: 
            if each_student['st_name'] == initial_data:
                continue
            entry_no = each_student['entry_no']
            
            _dept_id = each_student['dept_id']
            
            query_set_department = Department.objects.get(dept_id =_dept_id)
            
            dept_name = DepartmentSerializer(query_set_department,many=False).data['dept_name']

            _degree_id = each_student['degree_id']
            
            query_set_program = Program.objects.get(degree_id =_degree_id)
            
            degree_name = ProgramSerializer(query_set_program,many=False).data['degree_name']
            
            _hostel_id = each_student['hostel_id']
            
            query_set_hostel = Hostel.objects.get(hostel_id = _hostel_id)
            
            hostel_name = HostelSerializer(query_set_hostel,many=False).data['hostel_name']

            item = {
                'name': each_student['st_name'],
                'entry_no': each_student['entry_no'],
                'email': each_student['email'],
                'gender': each_student['gender'],
                'department':dept_name,
                'degree_name': degree_name,
                'hostel': hostel_name,
                'room_no': each_student['room_no'],
                'year_of_entry': str(each_student['year_of_entry']),
                'mobile_no': each_student['mobile_no'],
                'profile_img': each_student['profile_img'],                
                'degree_duration':'',
                'location_name':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
                'designation':'',
            }
            
            res.append(item)
            
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
def get_student_by_entry_no(request, entry_no):
    queryset = Student.objects.get(entry_no = entry_no)
    serializer = StudentSerializer(queryset, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def get_welcome_message(request):
    try:
        data = request.data
        
        email = data['email']
        
        name = ''
        
        queryset_person = Person.objects.get(email=email, is_present=True)
        
        serializer_person = PersonSerializer(queryset_person, many=False)
        
        person_type = serializer_person.data['person_type']
        
        if person_type == 'Student':
            queryset = Student.objects.get(email = email, is_present = True)        
            serializer = StudentSerializer(queryset, many=False)            
            name = serializer.data['st_name']
            
        elif person_type == 'Guard':
            queryset = Guard.objects.get(email = email, is_present = True)        
            serializer = GuardSerializer(queryset, many=False)            
            name = serializer.data['guard_name']
            
        elif person_type == 'Authority':
            queryset = Authorities.objects.get(email = email, is_present = True)        
            serializer = AuthoritiesSerializer(queryset, many=False)            
            name = serializer.data['authority_name']
            
        elif person_type == 'Admin':
            queryset = Admin.objects.get(email = email, is_present = True)        
            serializer = AdminSerializer(queryset, many=False)            
            name = serializer.data['admin_name']

        welcome_message = "Welcome " + name
        
        res = {
            "welcome_message":welcome_message,
        }
        
        return Response(res, status= status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception in get_student_by_email: " + str(e))
        
        welcome_message = "Welcome"
        
        res = {
            "welcome_message":welcome_message,
        }
        
        return Response(res, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

    
@api_view(['POST'])
def get_student_by_email(request):
    try:
        data = request.data
        
        email_ = data['email']

        queryset = Student.objects.get(email = email_)
        
        serializer = StudentSerializer(queryset, many=False)
        
        _dept_id = serializer.data['dept_id']
        
        query_set_department = Department.objects.get(dept_id =_dept_id)
        
        dept_name = DepartmentSerializer(query_set_department,many=False).data['dept_name']

        _degree_id = serializer.data['degree_id']
        
        query_set_department = Program.objects.get(degree_id =_degree_id)
        
        degree_name = ProgramSerializer(query_set_department,many=False).data['degree_name']

        res = {
            'name': serializer.data['st_name'],
            'email': serializer.data['email'],
            'gender': serializer.data['gender'],
            'year_of_entry': str(serializer.data['year_of_entry']),
            'department':dept_name,
            'mobile_no': serializer.data['mobile_no'],
            'profile_img': serializer.data['profile_img'],
            'degree': degree_name
        }
        
        return Response(res, status= status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception in get_student_by_email: " + str(e))
        return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)
        

@api_view(['POST'])
def add_student(request):
    data = request.data
    
    try:
        st_name_ = data['st_name']
        entry_no_ = data['entry_no']
        email_ = data['email']        
    
        queryset_student = Student.objects.create(
            st_name = st_name_,
            entry_no = entry_no_,
            email = email_,
            # profile_img = data['profile_img'],
        )       
        
        queryset_entry_no = Student.objects.get(entry_no = entry_no_)
        queryset_location_table = Location.objects.all()
        
        for each_queryset_location_table in queryset_location_table:
            queryset_status_table = StatusTable.objects.create(
                entry_no = queryset_entry_no,
                location_id = each_queryset_location_table,            
            )
            
        response_str = "Student Added Successfully"
        return Response(response_str)
    
    except Exception as e:
        response_str = "Failed to add student due to exception\n" + str(e)
        return Response(response_str)

@api_view(['POST'])
def add_new_location(request):
    data = request.data
    
    try:        
        new_location_name = data['new_location_name']
        chosen_parent_location = data['chosen_parent_location']
        chosen_pre_approval_needed = data['chosen_pre_approval_needed']
        automatic_exit_required_str = data['automatic_exit_required']
        
        approval_flag = False
        if chosen_pre_approval_needed == 'Yes':
            approval_flag = True   
            
        parent_id = -1
        if chosen_parent_location != 'None':
            queryset_location_table = Location.objects.get(location_name=chosen_parent_location)            
            serializer_location_table = LocationSerializer(queryset_location_table, many=False)    
            parent_id = serializer_location_table.data['location_id']
        
        automatic_exit_required = False
        if automatic_exit_required_str == 'Yes':
            automatic_exit_required = True 
        
        location_already_exists = len(Location.objects.filter(location_name = new_location_name)) != 0
        
        if location_already_exists:
            Location.objects.filter(location_name = new_location_name).update(            
                parent_id = parent_id,
                pre_approval_required = approval_flag,
                automatic_exit_required = automatic_exit_required, 
                is_present = True,         
            )
        
        else:        
            Location.objects.create(
                location_name = new_location_name,
                parent_id = parent_id,
                pre_approval_required = approval_flag,
                automatic_exit_required = automatic_exit_required, 
                is_present = True,         
            )        
        
        queryset_student = Student.objects.all()
        
        queryset_location_table = Location.objects.get(location_name = new_location_name)
        
        for each_queryset_student in queryset_student:
            StatusTable.objects.create(
                entry_no = each_queryset_student,
                location_id = queryset_location_table,    
                current_status = 'out',        
            )        
        
        response_str = "New location added successfully"
        return Response(response_str, status= status.HTTP_200_OK)

    except Exception as e:
        print("Exception in adding new location")
        response_str = "Failed to add new location"
        return Response(response_str, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def modify_locations(request):
    data = request.data
    
    try:        
        chosen_modify_location = data['chosen_modify_location']
        chosen_parent_location = data['chosen_parent_location']
        chosen_pre_approval_needed = data['chosen_pre_approval_needed']
        automatic_exit_required_str = data['automatic_exit_required']
        
        approval_flag = False
        if chosen_pre_approval_needed == 'Yes':
            approval_flag = True   
           
        automatic_exit_required = False
        if automatic_exit_required_str == 'Yes':
            automatic_exit_required = True 
        
        if chosen_parent_location == 'None':
            Location.objects.filter(location_name = chosen_modify_location).update(
                    parent_id = -1,
                    pre_approval_required = approval_flag,
                    automatic_exit_required = automatic_exit_required                    
                )           
        
        else:           
            queryset_location_table = Location.objects.get(location_name=chosen_modify_location)            
            serializer_location_table = LocationSerializer(queryset_location_table, many=False)    
            chosen_modify_location_id = serializer_location_table.data['location_id']
            # print("chosen_modify_location_id")
            # print(chosen_modify_location_id)
            
            queryset_location_table = Location.objects.get(location_name=chosen_parent_location)            
            serializer_location_table = LocationSerializer(queryset_location_table, many=False)  
            chosen_parent_location_id = serializer_location_table.data['location_id']
            new_parent_id = chosen_parent_location_id
            # print("new_parent_id")
            # print(new_parent_id)
            

            cycle_detected = False
            
            while True:
                queryset_location_table = Location.objects.get(location_id=chosen_parent_location_id)
                serializer_location_table = LocationSerializer(queryset_location_table, many=False)    
                parent_location_id = serializer_location_table.data['parent_id']
                
                # print("parent_location_id")
                # print(parent_location_id)
                
                
                
                if parent_location_id == -1:
                    # No cycle detected                
                    break
                
                elif parent_location_id == chosen_modify_location_id:
                    # Cycle detected
                    cycle_detected = True
                    break
                    
                else:
                    chosen_parent_location_id = parent_location_id
            
            if cycle_detected == False:
                Location.objects.filter(location_name = chosen_modify_location).update(
                    parent_id = new_parent_id,
                    pre_approval_required = approval_flag,
                    automatic_exit_required = automatic_exit_required                    
                )                  
                
                response_str = "Location updated successfully"
                return Response(response_str, status= status.HTTP_200_OK)
            
            else:
                response_str = "Location data cannot be updated as a cycle is present"
                return Response(response_str, status= status.HTTP_500_INTERNAL_SERVER_ERROR)
                

    except Exception as e:
        print("Exception in updating location data")
        response_str = "Failed to update location data"
        return Response(response_str, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def delete_location(request):
    data = request.data
    
    try:        
        to_delete_location_name = data['chosen_delete_location']
        
        Location.objects.filter(location_name=to_delete_location_name).update(is_present = False)   
        
        StatusTable.objects.filter(
            location_id = Location.objects.get(location_name=to_delete_location_name),       
        ).delete()             
        
        response_str = "Location deleted successfully"
        
        return Response(response_str, status= status.HTTP_200_OK)

    except Exception as e:
        print("Exception in delete location")
        print(e)
        response_str = "Failed to delete location"
        return Response(response_str, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

# @api_view(['GET'])
# def get_tickets_from_guard_ticket_table(request):
#     data = request.data
    
#     email_ = data['email']
#     queryset_entry_no = Student.objects.get(email = email_)
#     serializer_student_table = StudentSerializer(queryset_entry_no, many=False) 
#     entry_no_ = str(serializer_student_table.data['entry_no'])
    
#     queryset_ticket_table = TicketTable.objects.filter(entry_no = queryset_entry_no)
#     serializer_ticket_table = TicketTableSerializer(queryset_ticket_table, many=True)
#     return Response(serializer_ticket_table.data)   

@api_view(['POST'])
def get_tickets_for_student(request):
    data = request.data
    
    email_ = data['email']
    queryset_entry_no = Student.objects.get(email = email_)
    
    location = data['location']
    queryset_location_table = Location.objects.get(location_name = location)
    
    queryset_ticket_table = TicketTable.objects.filter(
        entry_no = queryset_entry_no,
        location_id = queryset_location_table)
    
    tickets_list = []
    
    for queryset_ticket in queryset_ticket_table:
        ticket = TicketTableSerializer(queryset_ticket, many=False)
        ResultObj = {}
        ResultObj['is_approved'] = ticket['is_approved'].value
        ResultObj['ticket_type'] = ticket['ticket_type'].value
        ResultObj['date_time'] =  ticket['date_time'].value
        location_id_ = ticket['location_id'].value
        queryset_location_table = Location.objects.get(location_id = location_id_) 
        serializer_location_table = LocationSerializer(queryset_location_table, many=False) 
        location_name = serializer_location_table.data['location_name']    
        ResultObj['location'] = location_name  
        
        entry_no_ = ticket['entry_no'].value  
        queryset_entry_no = Student.objects.get(entry_no = entry_no_) 
        serializer_entry_no = StudentSerializer(queryset_entry_no, many=False) 
        email_ = serializer_entry_no.data['email']       
        student_name = serializer_entry_no.data['st_name']       
        ResultObj['email'] = email_        
        ResultObj['student_name'] = student_name    
             
        ResultObj['authority_status'] = "NA"     
           
        tickets_list.append(ResultObj)

    tickets_list.reverse()
    return Response(tickets_list)

@api_view(['POST'])
def get_authority_tickets_for_students(request):    
    try:
        data = request.data
    
        email_ = data['email']
        
        location = data['location']
        
        queryset_entry_no = Student.objects.get(email = email_)
        
        queryset_location_table = Location.objects.get(location_name = location)
        
        queryset_ticket_table = AuthoritiesTicketTable.objects.filter(
            entry_no = queryset_entry_no,
            location_id = queryset_location_table)
        
        tickets_list = []
        
        for queryset_ticket in queryset_ticket_table:
            ticket = AuthoritiesTicketTableSerializer(queryset_ticket, many=False)
            
            ResultObj = {}
            
            ResultObj['is_approved'] = ticket['is_approved'].value
            
            ResultObj['ticket_type'] = ticket['ticket_type'].value
            
            ResultObj['date_time'] =  ticket['date_time'].value
            
            location_id_ = ticket['location_id'].value
            queryset_location_table = Location.objects.get(location_id = location_id_) 
            serializer_location_table = LocationSerializer(queryset_location_table, many=False) 
            location_name = serializer_location_table.data['location_name']    
            ResultObj['location'] = location_name  
            
            entry_no_ = ticket['entry_no'].value  
            queryset_entry_no = Student.objects.get(entry_no = entry_no_) 
            serializer_entry_no = StudentSerializer(queryset_entry_no, many=False) 
            email_ = serializer_entry_no.data['email']       
            student_name = serializer_entry_no.data['st_name']       
            
            ResultObj['email'] = email_        
            ResultObj['student_name'] = student_name    
            
            authority_status = ""
            
            try:
                # ref_id = ticket['ref_id'].value
            
                # queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.get(ref_id=ref_id)
                
                # serializer_authorities_ticket_table = AuthoritiesTicketTableSerializer(queryset_authorities_ticket_table, many=False)
                
                # auth_id = serializer_authorities_ticket_table.data['auth_id']
                
                auth_id = ticket['auth_id'].value
                
                queryset_authorities_table = Authorities.objects.get(auth_id = auth_id)
                
                serializer_authorities = AuthoritiesSerializer(queryset_authorities_table, many=False)
                
                authority_name = serializer_authorities.data['authority_name']
                
                authority_designation = serializer_authorities.data['authority_designation']
                
                authority_message = ticket['authority_message'].value
                
                is_approved = ticket['is_approved'].value
                
                authority_status = authority_name + ", " + authority_designation + "\n" + is_approved + "\n" + "authority_message: " + authority_message            
            
            except:
                authority_status = "NA"
                
            ResultObj['authority_status'] = authority_status
            
            # Use if required
            ResultObj['student_message'] = ticket['student_message'].value

            tickets_list.append(ResultObj)

        tickets_list.reverse()
        
        return Response(tickets_list, status = status.HTTP_200_OK)
    
    except:
        res = []
        return Response(res, status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def get_pending_tickets_for_guard(request):
    try:
        data = request.data
        
        location = data['location']
        enter_exit = data['enter_exit']
        
        queryset_location_table = Location.objects.get(location_name = location)
        
        queryset_ticket_table = TicketTable.objects.filter(
            location_id = queryset_location_table, 
            is_approved = 'Pending',
            ticket_type = enter_exit)
        
        pending_tickets_list = []
        
        for queryset_ticket in queryset_ticket_table:
            ticket = TicketTableSerializer(queryset_ticket, many=False)
            ResultObj = {}
            ResultObj['is_approved'] = ticket['is_approved'].value
            ResultObj['ticket_type'] = ticket['ticket_type'].value
            ResultObj['date_time'] =  ticket['date_time'].value
            location_id_ = ticket['location_id'].value
            queryset_location_table = Location.objects.get(location_id = location_id_) 
            serializer_location_table = LocationSerializer(queryset_location_table, many=False) 
            location_name = serializer_location_table.data['location_name']    
            ResultObj['location'] = location_name  
            
            entry_no_ = ticket['entry_no'].value  
            queryset_entry_no = Student.objects.get(entry_no = entry_no_) 
            serializer_entry_no = StudentSerializer(queryset_entry_no, many=False) 
            email_ = serializer_entry_no.data['email']       
            student_name = serializer_entry_no.data['st_name']       
            ResultObj['email'] = email_        
            ResultObj['student_name'] = student_name    
            
            ref_id = ticket['ref_id'].value
            
            authority_status = ""
            
            try:
            
                queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.get(ref_id=ref_id)
                
                serializer_authorities_ticket_table = AuthoritiesTicketTableSerializer(queryset_authorities_ticket_table, many=False)
                
                auth_id = serializer_authorities_ticket_table.data['auth_id']
                
                queryset_authorities_table = Authorities.objects.get(auth_id = auth_id)
                
                serializer_authorities = AuthoritiesSerializer(queryset_authorities_table, many=False)
                
                authority_name = serializer_authorities.data['authority_name']
                
                authority_designation = serializer_authorities.data['authority_designation']
                
                authority_message = serializer_authorities_ticket_table.data['authority_message']
                is_approved = serializer_authorities_ticket_table.data['is_approved']
                
                authority_status = authority_name + ", " + authority_designation + "\n" + is_approved + "\n" + "authority_message: " + authority_message            
            
            except:
                authority_status = "NA"
                
            ResultObj['authority_status'] = authority_status   
            
            pending_tickets_list.append(ResultObj)
        
        
        pending_tickets_list.reverse()
        
        return Response(pending_tickets_list, status = status.HTTP_200_OK)
    
    except Exception as e:
        pending_tickets_list = []
        print("Exception in get_pending_tickets_for_guard: " + str(e))
        return Response(pending_tickets_list,status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def get_pending_tickets_for_visitors(request):
    try:
        data = request.data
        
        enter_exit = data['enter_exit']
        queryset_visitor_ticket_table = VisitorTicketTable.objects.filter(ticket_type = enter_exit, guard_status = 'Pending')
        
        serializer_visitor_ticket_table = VisitorTicketTableSerializer(queryset_visitor_ticket_table, many=True)
        
        pending_tickets_list = []
        
        for visitor_tickets in serializer_visitor_ticket_table.data:
            ResultObj = {}
            visitor_id = visitor_tickets['visitor_id']   
            queryset_visitor = Visitor.objects.get(visitor_id = visitor_id)
            serializer_visitor = VisitorSerializer(queryset_visitor, many=False)
            
            
            auth_id = visitor_tickets['auth_id']
            queryset_authorities = Authorities.objects.get(auth_id = auth_id)
            serializer_authorities = AuthoritiesSerializer(queryset_authorities, many=False)
            
            ResultObj['visitor_name'] = serializer_visitor.data['visitor_name']
            ResultObj['mobile_no'] = serializer_visitor.data['mobile_no']
            ResultObj['current_status'] = serializer_visitor.data['current_status']
            ResultObj['car_number'] = visitor_tickets['car_number']
            ResultObj['authority_name'] = serializer_authorities.data['authority_name']
            ResultObj['authority_email'] = serializer_authorities.data['email']           
            ResultObj['authority_designation'] = serializer_authorities.data['authority_designation']
            ResultObj['purpose'] = visitor_tickets['purpose']
            ResultObj['authority_status'] = visitor_tickets['authority_status']
            ResultObj['authority_message'] = visitor_tickets['authority_message']
            ResultObj['date_time_of_ticket_raised'] = visitor_tickets['date_time_of_ticket_raised']
            ResultObj['date_time_authority'] = visitor_tickets['date_time_authority']
            ResultObj['date_time_guard'] = visitor_tickets['date_time_guard']
            ResultObj['date_time_of_exit'] = visitor_tickets['date_time_of_exit']
            ResultObj['guard_status'] = visitor_tickets['guard_status']
            ResultObj['ticket_type'] = visitor_tickets['ticket_type']
            ResultObj['visitor_ticket_id'] = visitor_tickets['visitor_ticket_id']
            ResultObj['duration_of_stay'] = visitor_tickets['duration_of_stay']
            
            pending_tickets_list.append(ResultObj)
      
        pending_tickets_list.reverse()
        
        return Response(pending_tickets_list, status = status.HTTP_200_OK)
    
    except Exception as e:
        pending_tickets_list = []
        print("Exception in get_pending_tickets_for_visitors: " + str(e))
        return Response(pending_tickets_list, status = status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def get_pending_visitor_tickets_for_authorities(request):
    try:
        data = request.data
        
        authority_email = data['authority_email']

        queryset_authorities_table = Authorities.objects.get(email = authority_email)

        serializer_authorities_table = AuthoritiesSerializer(queryset_authorities_table, many=False)

        auth_id = serializer_authorities_table.data['auth_id']
        
        queryset_visitor_ticket_table = VisitorTicketTable.objects.filter(auth_id = auth_id, authority_status = 'Pending')
        
        serializer_visitor_ticket_table = VisitorTicketTableSerializer(queryset_visitor_ticket_table, many=True)
        
        pending_tickets_list = []
        for visitor_tickets in serializer_visitor_ticket_table.data:
            ResultObj = {}
            visitor_id = visitor_tickets['visitor_id']   
            queryset_visitor = Visitor.objects.get(visitor_id = visitor_id)
            serializer_visitor = VisitorSerializer(queryset_visitor, many=False)            
            
            auth_id = visitor_tickets['auth_id']
            queryset_authorities = Authorities.objects.get(auth_id = auth_id)
            serializer_authorities = AuthoritiesSerializer(queryset_authorities, many=False)
            
            ResultObj['visitor_name'] = serializer_visitor.data['visitor_name']
            ResultObj['mobile_no'] = serializer_visitor.data['mobile_no']
            ResultObj['current_status'] = serializer_visitor.data['current_status']
            ResultObj['car_number'] = visitor_tickets['car_number']
            ResultObj['authority_name'] = serializer_authorities.data['authority_name']
            ResultObj['authority_email'] = serializer_authorities.data['email']           
            ResultObj['authority_designation'] = serializer_authorities.data['authority_designation']
            ResultObj['purpose'] = visitor_tickets['purpose']
            ResultObj['authority_status'] = visitor_tickets['authority_status']
            ResultObj['authority_message'] = visitor_tickets['authority_message']
            ResultObj['date_time_of_ticket_raised'] = visitor_tickets['date_time_of_ticket_raised']
            ResultObj['date_time_authority'] = visitor_tickets['date_time_authority']
            ResultObj['date_time_guard'] = visitor_tickets['date_time_guard']
            ResultObj['date_time_of_exit'] = visitor_tickets['date_time_of_exit']
            ResultObj['guard_status'] = visitor_tickets['guard_status']
            ResultObj['ticket_type'] = visitor_tickets['ticket_type']
            ResultObj['visitor_ticket_id'] = visitor_tickets['visitor_ticket_id']
            ResultObj['duration_of_stay'] = visitor_tickets['duration_of_stay']
            
            pending_tickets_list.append(ResultObj)
        pending_tickets_list.reverse()
        
        return Response(pending_tickets_list, status = status.HTTP_200_OK)
    
    except Exception as e:
        pending_tickets_list = []
        print("Exception in get_pending_visitor_tickets_for_authorities: " + str(e))
        return Response(pending_tickets_list, status = status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def get_past_visitor_tickets_for_authorities(request):
    try:
        data = request.data
        
        authority_email = data['authority_email']

        queryset_authorities_table = Authorities.objects.get(email = authority_email)

        serializer_authorities_table = AuthoritiesSerializer(queryset_authorities_table, many=False)

        auth_id = serializer_authorities_table.data['auth_id']
        
        queryset_visitor_ticket_table = VisitorTicketTable.objects.filter(auth_id = auth_id).exclude(authority_status = 'Pending')
        
        serializer_visitor_ticket_table = VisitorTicketTableSerializer(queryset_visitor_ticket_table, many=True)
        
        past_tickets_list = []
        for visitor_tickets in serializer_visitor_ticket_table.data:
            ResultObj = {}
            visitor_id = visitor_tickets['visitor_id']   
            queryset_visitor = Visitor.objects.get(visitor_id = visitor_id)
            serializer_visitor = VisitorSerializer(queryset_visitor, many=False)            
            
            auth_id = visitor_tickets['auth_id']
            queryset_authorities = Authorities.objects.get(auth_id = auth_id)
            serializer_authorities = AuthoritiesSerializer(queryset_authorities, many=False)
            
            ResultObj['visitor_name'] = serializer_visitor.data['visitor_name']
            ResultObj['mobile_no'] = serializer_visitor.data['mobile_no']
            ResultObj['current_status'] = serializer_visitor.data['current_status']
            ResultObj['car_number'] = visitor_tickets['car_number']
            ResultObj['authority_name'] = serializer_authorities.data['authority_name']
            ResultObj['authority_email'] = serializer_authorities.data['email']           
            ResultObj['authority_designation'] = serializer_authorities.data['authority_designation']
            ResultObj['purpose'] = visitor_tickets['purpose']
            ResultObj['authority_status'] = visitor_tickets['authority_status']
            ResultObj['authority_message'] = visitor_tickets['authority_message']
            ResultObj['date_time_of_ticket_raised'] = visitor_tickets['date_time_of_ticket_raised']
            ResultObj['date_time_authority'] = visitor_tickets['date_time_authority']
            ResultObj['date_time_guard'] = visitor_tickets['date_time_guard']
            ResultObj['date_time_of_exit'] = visitor_tickets['date_time_of_exit']
            ResultObj['guard_status'] = visitor_tickets['guard_status']
            ResultObj['ticket_type'] = visitor_tickets['ticket_type']
            ResultObj['visitor_ticket_id'] = visitor_tickets['visitor_ticket_id']
            ResultObj['duration_of_stay'] = visitor_tickets['duration_of_stay']
            
            past_tickets_list.append(ResultObj)
        past_tickets_list.reverse()
        
        return Response(past_tickets_list, status = status.HTTP_200_OK)
    
    except Exception as e:
        past_tickets_list = []
        print("Exception in get_past_visitor_tickets_for_authorities: " + str(e))
        return Response(past_tickets_list, status = status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def get_pending_tickets_for_authorities(request):
    try:
        data = request.data
        
        authority_email = data['authority_email']
        
        queryset_authorities_table = Authorities.objects.get(email = authority_email)        
        
        queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.filter(
            auth_id = queryset_authorities_table, 
            is_approved = 'Pending')
        
        pending_tickets_list = []
        
        for queryset_ticket in queryset_authorities_ticket_table:
            ticket = AuthoritiesTicketTableSerializer(queryset_ticket, many=False)
            
            ResultObj = {}
            
            ResultObj['is_approved'] = ticket['is_approved'].value
            
            ResultObj['ticket_type'] = ticket['ticket_type'].value
            
            ResultObj['date_time'] =  ticket['date_time'].value
            
            location_id_ = ticket['location_id'].value
            queryset_location_table = Location.objects.get(location_id = location_id_) 
            serializer_location_table = LocationSerializer(queryset_location_table, many=False) 
            location_name = serializer_location_table.data['location_name']    
            ResultObj['location'] = location_name  
            
            entry_no_ = ticket['entry_no'].value  
            queryset_entry_no = Student.objects.get(entry_no = entry_no_) 
            serializer_entry_no = StudentSerializer(queryset_entry_no, many=False) 
            email_ = serializer_entry_no.data['email']       
            student_name = serializer_entry_no.data['st_name']    
               
            ResultObj['email'] = email_    
                
            ResultObj['student_name'] = student_name    
                
            ResultObj['authority_message'] = ticket['authority_message'].value     
          
            pending_tickets_list.append(ResultObj)
        
        # Thus the fields are [is_approved,ticket_type,date_time,location,email,student_name,authority_message]
        pending_tickets_list.reverse()
        
        return Response(pending_tickets_list, status = status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception in get_pending_tickets_for_guard: " + str(e))
        return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def get_tickets_for_guard(request):
    try:
        data = request.data
        
        location = data['location']
        enter_exit = data['enter_exit']
        queryset_location_table = Location.objects.get(location_name = location)
        
        is_approved_ = data['is_approved']    
        
        queryset_ticket_table = TicketTable.objects.filter(
            location_id = queryset_location_table, 
            is_approved = is_approved_,
            ticket_type = enter_exit)
        
        tickets_list = []
        
        for queryset_ticket in queryset_ticket_table:
            ticket = TicketTableSerializer(queryset_ticket, many=False)
            ResultObj = {}
            ResultObj['is_approved'] = ticket['is_approved'].value
            ResultObj['ticket_type'] = ticket['ticket_type'].value
            ResultObj['date_time'] =  ticket['date_time'].value
            location_id_ = ticket['location_id'].value
            queryset_location_table = Location.objects.get(location_id = location_id_) 
            serializer_location_table = LocationSerializer(queryset_location_table, many=False) 
            location_name = serializer_location_table.data['location_name']    
            ResultObj['location'] = location_name  
            
            entry_no_ = ticket['entry_no'].value  
            queryset_entry_no = Student.objects.get(entry_no = entry_no_) 
            serializer_entry_no = StudentSerializer(queryset_entry_no, many=False) 
            email_ = serializer_entry_no.data['email']       
            student_name = serializer_entry_no.data['st_name']       
            ResultObj['email'] = email_        
            ResultObj['student_name'] = student_name    
            
            ref_id = ticket['ref_id'].value
            
            authority_status = ""
            
            try:
            
                queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.get(ref_id=ref_id)
                
                serializer_authorities_ticket_table = AuthoritiesTicketTableSerializer(queryset_authorities_ticket_table, many=False)
                
                auth_id = serializer_authorities_ticket_table.data['auth_id']
                
                queryset_authorities_table = Authorities.objects.get(auth_id = auth_id)
                
                serializer_authorities = AuthoritiesSerializer(queryset_authorities_table, many=False)
                
                authority_name = serializer_authorities.data['authority_name']
                
                authority_designation = serializer_authorities.data['authority_designation']
                
                authority_message = serializer_authorities_ticket_table.data['authority_message']
                is_approved = serializer_authorities_ticket_table.data['is_approved']
                
                authority_status = authority_name + ", " + authority_designation + "\n" + is_approved + "\n" + "authority_message: " + authority_message            
            
            except:
                authority_status = "NA"
                
            ResultObj['authority_status'] = authority_status 
            
            # print("ResultObj")
            # print(ResultObj)
            tickets_list.append(ResultObj)
        
        # json_str = json.dumps(tickets_list)
        # print(json_str)
        tickets_list.reverse()

        return Response(tickets_list)
    
    except Exception as e:
        print("Exception in get_tickets_for_guard: " + str(e))
        return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def get_list_of_entry_numbers(request):
    try:
        queryset_student = Student.objects.filter(is_present=True)
        
        res = []
        serializer = StudentSerializer(queryset_student, many=True)
        
        for current_student in serializer.data:
            if current_student['st_name'] == initial_data:
                continue
            obj = {
                'entry_no': current_student['entry_no'],
                'st_name': current_student['st_name'],
                'email': current_student['email'],
            }    
            res.append(obj)
            
        return Response(res, status=status.HTTP_200_OK) 
    
    except Exception as e:
        # print("Exception in get_tickets_for_guard: " + str(e))
        return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def get_list_of_visitors(request):
    try:
        queryset_visitor = Visitor.objects.filter(is_present=True)
        
        res = []
        
        serializer = VisitorSerializer(queryset_visitor, many=True)
        
        for current_visitor in serializer.data:
            if current_visitor['visitor_name'] == initial_data:
                continue
            obj = {
                'visitor_name': current_visitor['visitor_name'],
                'mobile_no': current_visitor['mobile_no'],                
                # 'current_status' : current_visitor['current_status'],
                # 'car_number' : current_visitor['car_number'],
                # 'authority_name' : current_visitor['authority_name'],
                # 'authority_email' : current_visitor['authority_email'],
                # 'authority_designation' : current_visitor['authority_designation'],
                # 'purpose' : current_visitor['purpose'],
                # 'authority_status' : current_visitor['authority_status'],
                # 'authority_message' : current_visitor['authority_message'],
                # 'date_time_of_ticket_raised' : current_visitor['date_time_of_ticket_raised'],
                # 'date_time_authority' : current_visitor['date_time_authority'],
                # 'date_time_guard' : current_visitor['date_time_guard'],
                # 'date_time_of_exit' : current_visitor['date_time_of_exit'],
                # 'guard_status' : current_visitor['guard_status'],
                # 'ticket_type' : current_visitor['ticket_type'],
                # 'visitor_ticket_id' : current_visitor['visitor_ticket_id'],
            }    
            res.append(obj)
            
        return Response(res, status=status.HTTP_200_OK) 
    
    except Exception as e:
        return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def get_tickets_for_authorities(request):
    try:
        data = request.data
        
        authority_email = data['authority_email']
        
        queryset_authorities_table = Authorities.objects.get(email = authority_email)
         
        is_approved_ = data['is_approved']    
        
        queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.filter(
            auth_id = queryset_authorities_table, 
            is_approved = is_approved_)
        
        tickets_list = []
        
        for queryset_ticket in queryset_authorities_ticket_table:
            ticket = AuthoritiesTicketTableSerializer(queryset_ticket, many=False)
            ResultObj = {}
            
            ResultObj['is_approved'] = ticket['is_approved'].value
            
            ResultObj['ticket_type'] = ticket['ticket_type'].value
            
            ResultObj['date_time'] =  ticket['date_time'].value
            
            location_id_ = ticket['location_id'].value
            
            queryset_location_table = Location.objects.get(location_id = location_id_) 
            serializer_location_table = LocationSerializer(queryset_location_table, many=False) 
            location_name = serializer_location_table.data['location_name']    
            ResultObj['location'] = location_name  
            
            entry_no_ = ticket['entry_no'].value  
            queryset_entry_no = Student.objects.get(entry_no = entry_no_) 
            serializer_entry_no = StudentSerializer(queryset_entry_no, many=False) 
            email_ = serializer_entry_no.data['email']       
            student_name = serializer_entry_no.data['st_name']   
                
            ResultObj['email'] = email_        
            ResultObj['student_name'] = student_name    
                
            ResultObj['authority_message'] = ticket['authority_message'].value    
            
            tickets_list.append(ResultObj)
        
        tickets_list.reverse()

        # Thus the fields are [is_approved, ticket_type, date_time, location, email, student_name, authority_message]
        return Response(tickets_list)
    
    except Exception as e:
        print("Exception in get_tickets_for_guard: " + str(e))
        return Response(status = status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def get_student_status(request):
    try:
        email_ = request.data['email'] 
        
        location_name_ = request.data['location']
        
        # Finding current status of this student for the current location   
             
        queryset_entry_no = Student.objects.get(email = email_)
        
        queryset_location_table = Location.objects.get(location_name = location_name_)
        
        serializer_location_table = LocationSerializer(queryset_location_table,many=False)
        
        current_location_id = serializer_location_table.data['location_id']
        
        parent_id = serializer_location_table.data['parent_id']
        
        queryset_status_table = StatusTable.objects.get(
            entry_no = queryset_entry_no,
            location_id = queryset_location_table
        )
        
        serializer_status_table = StatusTableSerializer(queryset_status_table, many=False)
        
        current_status = serializer_status_table.data['current_status']
        
        
        
        # Find its parent location and thi status of the student for the parent location
        
        inside_parent_location = "true"       
        
        if parent_id != -1:
            try:
                queryset_parent = Location.objects.get(location_id = parent_id)
                
                queryset_status_table = StatusTable.objects.get(
                    entry_no = queryset_entry_no,
                    location_id = queryset_parent,
                )
                
                serializer_status_table = StatusTableSerializer(queryset_status_table, many=False)
                
                current_status_of_student_in_parent = serializer_status_table.data['current_status']
                
                if current_status_of_student_in_parent == 'out':
                    inside_parent_location = "false"
             
            except:
                pass
        
        
        
        # Finding child location and the status of the student for the child location
        
        exited_all_children = "true"
        
        queryset_location_all = Location.objects.all()
        
        for each_location in queryset_location_all:
            
            serializer = LocationSerializer(each_location, many=False)
            
            potential_same_id = serializer.data['parent_id'] 
            
            if current_location_id == potential_same_id:
                
                queryset_status_table = StatusTable.objects.get(
                    entry_no = queryset_entry_no,
                    location_id = each_location,
                )
                
                serializer_status_table = StatusTableSerializer(queryset_status_table, many=False)
                
                current_status_of_student_in_child = serializer_status_table.data['current_status']
                
                if current_status_of_student_in_child == 'in':
                    
                    exited_all_children = "false"
                    
                    break
                  
        res = {}
        
        res["in_or_out"] = current_status
        
        res["inside_parent_location"] = inside_parent_location
        
        res["exited_all_children"] = exited_all_children
        
        return Response(res, status=status.HTTP_200_OK)
    
    except Exception as e:
        
        print("Exception in get_student_status: " + str(e))
        
        res = {}
        
        res["in_or_out"] = "Invalid Status"
        
        res["inside_parent_location"] = ""
        
        res["exited_all_children"] = ""
        
        return Response(res, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

@api_view(['POST'])
def insert_in_guard_ticket_table(request):
    try:
        data = request.data
        email_ = data['email']
        queryset_entry_no = Student.objects.get(email = email_)
        
        location_ = data['location']
        queryset_location_table = Location.objects.get(location_name = location_)
        
        # queryset_ref_id = AuthoritiesTicketTable.objects.get(ref_id = 1)

        ticket_type_ = str(data['ticket_type'])    
        
        date_time_ = str(data['date_time'])
        
        choosen_authority_ticket = str(data['choosen_authority_ticket'])
        
        if choosen_authority_ticket == "" or choosen_authority_ticket == "None":      
            queryset = TicketTable.objects.create(
                location_id = queryset_location_table,
                entry_no = queryset_entry_no,
                # ref_id = queryset_ref_id,
                ticket_type = ticket_type_,
                date_time = date_time_,
            )
        
        else:
            ref_id = int(choosen_authority_ticket.split("\n")[3])
            
            queryset_ref_id = AuthoritiesTicketTable.objects.get(ref_id=ref_id)
            
            queryset = TicketTable.objects.create(
                location_id = queryset_location_table,
                entry_no = queryset_entry_no,
                ref_id = queryset_ref_id,
                ticket_type = ticket_type_,
                date_time = date_time_,
            )
            
        # If the student has raised an entry ticket, then mark the status of student as "pending_entry"
        if ticket_type_ == 'enter':
            queryset_status_table = StatusTable.objects.filter(
                entry_no = queryset_entry_no, 
                location_id = queryset_location_table).update(
                    current_status = "pending_entry"
                )    
            print("is status updated by insert into guard ticket table backend")
            print("Status Table")
            print(StatusTable.objects.all())      
            
        elif ticket_type_ == 'exit':
            queryset_status_table = StatusTable.objects.filter(
                entry_no = queryset_entry_no, 
                location_id = queryset_location_table).update(
                    current_status = "pending_exit"
                )  
        
        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        print("insert into guard ticket table raised exception")
        print(e)
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)
        

@api_view(['POST'])
def insert_in_authorities_ticket_table(request):
    try:
        data = request.data
        
        chosen_authority = data['chosen_authority']
        ticket_type = data['ticket_type']
        student_message = data['student_message']
        email = data['email']
        date_time = data['date_time']
        location = data['location']
        
        authority_email = str(chosen_authority.split("\n")[1])
        
        print("authority_email in backend printed: " + authority_email)
        
        queryset_entry_no = Student.objects.get(email = email)
        
        queryset_location_table = Location.objects.get(location_name = location)
        
        queryset_authorities_table = Authorities.objects.get(email = authority_email)
        
        queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.create(
            auth_id = queryset_authorities_table,
            entry_no = queryset_entry_no,
            date_time = date_time,
            location_id = queryset_location_table,
            ticket_type = ticket_type,
            student_message = student_message,
            is_approved = "Pending",
        )
        
        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        print("insert_in_authorities_ticket_table raised exception: " + str(e))
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def accept_selected_tickets(request):
    try:
        list_data = request.data
        
        for data in list_data:
            # print(data)
            location = data['location']
            is_approved_ = data['is_approved']
            ticket_type_ = data['ticket_type']
            date_time_ = data['date_time']
            email_ = data['email']
            queryset_location_table = Location.objects.get(location_name = location)
            queryset_entry_no = Student.objects.get(email = email_)

            queryset_ticket_table = TicketTable.objects.filter(
                entry_no = queryset_entry_no, 
                location_id = queryset_location_table, 
                date_time = date_time_).update(
                    is_approved = "Approved"
                )
            
            # If the ticket is an entry ticket and the guard has pressed approved, then mark the current status of that person as "in"
            if ticket_type_ == 'enter':
                queryset_status_table = StatusTable.objects.filter(
                    entry_no = queryset_entry_no, 
                    location_id = queryset_location_table).update(
                        current_status = "in"
                    )
            # If the ticket is an exit ticket and the guard has pressed approved, then mark the current status of that person as "out"
            elif ticket_type_ == 'exit':
                queryset_status_table = StatusTable.objects.filter(
                    entry_no = queryset_entry_no, 
                    location_id = queryset_location_table).update(
                        current_status = "out"
                    )

        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        print("accepted selected tickets raised exception: " + str(e))
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def accept_selected_tickets_visitors(request):
    try:
        list_data = request.data
        
        for data in list_data:
            
            visitor_name = data['visitor_name']
            mobile_no = data['mobile_no']
            current_status = data['current_status']
            car_number = data['car_number']
            authority_name = data['authority_name']
            authority_email = data['authority_email']
            authority_designation = data['authority_designation']
            purpose = data['purpose']
            authority_status = data['authority_status']
            authority_message = data['authority_message']
            date_time_of_ticket_raised = data['date_time_of_ticket_raised']
            date_time_authority = data['date_time_authority']
            date_time_guard = data['date_time_guard']
            date_time_of_exit = data['date_time_of_exit']
            guard_status = data['guard_status']
            ticket_type = data['ticket_type']
            visitor_ticket_id = data['visitor_ticket_id']
            
            if authority_status == 'Pending':
                continue
            
            queryset_visitor = Visitor.objects.get(visitor_name = visitor_name, mobile_no = mobile_no)
            serializer_visitor = VisitorSerializer(queryset_visitor, many=False)
            visitor_id = serializer_visitor.data['visitor_id']
            
            # If the ticket is an entry ticket and the guard has pressed approved, then mark the current status of that person as "in" and thereafter change it to "pending_exit"
            if ticket_type == 'enter':
                VisitorTicketTable.objects.filter(
                    visitor_ticket_id = visitor_ticket_id).update(
                        guard_status = "Pending", 
                        ticket_type = "exit",
                        date_time_guard = datetime.now())
                
                Visitor.objects.filter(visitor_id = visitor_id).update(
                    current_status = "pending_exit"
                )
                
            # If the ticket is an exit ticket and the guard has pressed approved, then mark the current status of that person as "out"
            elif ticket_type == 'exit':
                VisitorTicketTable.objects.filter(
                    visitor_ticket_id = visitor_ticket_id).update(
                        guard_status = "Approved", 
                        # ticket_type = "enter",
                        date_time_guard = datetime.now())
                
                Visitor.objects.filter(visitor_id = visitor_id).update(
                    current_status = "out"
                )                

        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        print("Accept selected tickets for visitors raised exception: " + str(e))
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def accept_selected_tickets_authorities(request):
    try:
        list_data = request.data
        
        # Fields are [is_approved, ticket_type, date_time, location, email, student_name, authority_message]
        
        for data in list_data:
            location = data['location']
            
            is_approved_ = data['is_approved']
            
            ticket_type_ = data['ticket_type']
            
            date_time_ = data['date_time']
            
            email_ = data['email']
            
            authority_message = data['authority_message']
            
            queryset_location_table = Location.objects.get(location_name = location)
            
            queryset_entry_no = Student.objects.get(email = email_)
            
            # Update the status to "Approved" and also update the authority message
            queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.filter(
                entry_no = queryset_entry_no, 
                location_id = queryset_location_table, 
                date_time = date_time_).update(
                    is_approved = "Approved",
                    authority_message = authority_message,
                )

        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        
        print("Exception in accept_selected_tickets_authorities: " + str(e))
        
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def reject_selected_tickets(request):
    try:
        list_data = request.data
        
        for data in list_data:          
            location = data['location']
            is_approved_ = data['is_approved']
            ticket_type_ = data['ticket_type']
            date_time_ = data['date_time']
            email_ = data['email']
            queryset_location_table = Location.objects.get(location_name = location)
            queryset_entry_no = Student.objects.get(email = email_)

            queryset_ticket_table = TicketTable.objects.filter(
                entry_no = queryset_entry_no, 
                location_id = queryset_location_table, 
                date_time = date_time_).update(
                    is_approved = "Rejected"
                )
            
            # If the ticket is an entry ticket and the guard has pressed rejected, then mark the current status of that person as "out"
            if ticket_type_ == 'enter':
                queryset_status_table = StatusTable.objects.filter(
                    entry_no = queryset_entry_no, 
                    location_id = queryset_location_table).update(
                        current_status = "out"
                    )
            # If the ticket is an exit ticket and the guard has pressed rejected, then mark the current status of that person as "in"
            elif ticket_type_ == 'exit':
                queryset_status_table = StatusTable.objects.filter(
                    entry_no = queryset_entry_no, 
                    location_id = queryset_location_table).update(
                        current_status = "in"
                    )

        return Response(status= status.HTTP_200_OK)
    except Exception as e:
        print("reject selected tickets raised exception")
        print(e)
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def reject_selected_tickets_visitors(request):
    try:
        list_data = request.data
        
        for data in list_data:
            
            visitor_name = data['visitor_name']
            mobile_no = data['mobile_no']
            current_status = data['current_status']
            car_number = data['car_number']
            authority_name = data['authority_name']
            authority_email = data['authority_email']
            authority_designation = data['authority_designation']
            purpose = data['purpose']
            authority_status = data['authority_status']
            authority_message = data['authority_message']
            date_time_of_ticket_raised = data['date_time_of_ticket_raised']
            date_time_authority = data['date_time_authority']
            date_time_guard = data['date_time_guard']
            date_time_of_exit = data['date_time_of_exit']
            guard_status = data['guard_status']
            ticket_type = data['ticket_type']
            visitor_ticket_id = data['visitor_ticket_id']
            
            if authority_status == 'Pending':
                continue
            
            queryset_visitor = Visitor.objects.get(visitor_name = visitor_name, mobile_no = mobile_no)
            serializer_visitor = VisitorSerializer(queryset_visitor, many=False)
            visitor_id = serializer_visitor.data['visitor_id']
            
            # If the ticket is an entry ticket and the guard has pressed rejected, then mark the current status of that person as "out"
            if ticket_type == 'enter':
                VisitorTicketTable.objects.filter(
                    visitor_ticket_id = visitor_ticket_id).update(
                        guard_status = "Rejected", 
                        # ticket_type = "exit",
                        date_time_guard = datetime.now())
                
                Visitor.objects.filter(visitor_id = visitor_id).update(
                    current_status = "out"
                )
                
            # If the ticket is an exit ticket and the guard has pressed approved, then mark the current status of that person as "out"
            elif ticket_type == 'exit':
                VisitorTicketTable.objects.filter(
                    visitor_ticket_id = visitor_ticket_id).update(
                        guard_status = "Rejected", 
                        # ticket_type = "enter",
                        date_time_guard = datetime.now())
                
                Visitor.objects.filter(visitor_id = visitor_id).update(
                    current_status = "in"
                )                

        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        print("accepted selected tickets for visitors raised exception: " + str(e))
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def reject_selected_tickets_authorities(request):
    try:
        list_data = request.data
        
        # Fields are [is_approved, ticket_type, date_time, location, email, student_name, authority_message]
        
        for data in list_data:     
                          
            location = data['location']
            
            is_approved_ = data['is_approved']
            
            ticket_type_ = data['ticket_type']
            
            date_time_ = data['date_time']
            
            email_ = data['email']
            
            authority_message = data['authority_message']
            
            queryset_location_table = Location.objects.get(location_name = location)
            
            queryset_entry_no = Student.objects.get(email = email_)

            # Update the status to "Rejected" and also update the authority message
            queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.filter(
                entry_no = queryset_entry_no, 
                location_id = queryset_location_table, 
                date_time = date_time_).update(
                    is_approved = "Rejected",
                    authority_message = authority_message,                    
                )

        return Response(status= status.HTTP_200_OK)
    
    except Exception as e:
        print("Exception in reject_selected_tickets_authorities: " + str(e))
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def approve_all_tickets(request):
    queryset_ticket_table = TicketTable.objects.filter(is_approved = "Pending").update(is_approved = "Approved")
    if int(queryset_ticket_table) == 0:
        return Response(status= status.HTTP_200_OK)
    serializer_ticket_table = TicketTableSerializer(queryset_ticket_table, many=True)
    # return Response(serializer_ticket_table.data)
    return Response(status= status.HTTP_200_OK)

@api_view(['POST'])
def reject_all_tickets(request):
    queryset_ticket_table = TicketTable.objects.filter(is_approved = "Pending").update(is_approved = "Rejected")
    if int(queryset_ticket_table) == 0:
        return Response(status= status.HTTP_200_OK)
    serializer_ticket_table = TicketTableSerializer(queryset_ticket_table, many=True)
    # return Response(serializer_ticket_table.data)
    
    return Response(status= status.HTTP_200_OK)


@api_view(['POST'])
def get_guard_tickets_by_location(request):
    data = request.data
    location_name_ = data['location_name']
    is_approved_ = data['is_approved']

    queryset_location_table = Location.objects.get(location_name = location_name_)

    queryset_ticket_table = TicketTable.objects.filter(location_id = queryset_location_table, is_approved = is_approved_)
    
    serializer_ticket_table = TicketTableSerializer(queryset_ticket_table, many=True)
    
    return Response(serializer_ticket_table.data)

################## Locations
@api_view(['POST'])
def get_all_locations(request):
    res=[]
    query_set = Location.objects.all()
    for each_query_set in query_set:
        serializer = LocationSerializer(each_query_set, many=False)
        location_name = serializer.data['location_name'] 
        is_present = serializer.data['is_present']
        if location_name!= initial_data and is_present:
            ResultObj = {'location_name': location_name}
            ResultObj['pre_approval'] = serializer.data['pre_approval_required']
            res.append(ResultObj)
    output = {
        "output": res
    }
    return Response(output, status.HTTP_200_OK)

@api_view(['GET','POST'])
def view_all_locations(request):
    res = []
    try:
        queryset = Location.objects.filter(is_present=True)
        
        serializer = LocationSerializer(queryset, many=True)
        
        for each_location in serializer.data: 
            if each_location['location_name'] == initial_data:
                continue
            
            _parent_id = each_location['parent_id']
            parent_location = "NA"
            if int(_parent_id) != -1:
                query_set_location = Location.objects.get(location_id = _parent_id)
                
                parent_location = LocationSerializer(query_set_location,many=False).data['location_name']

            _pre_approval_required = "No"
            if each_location['pre_approval_required']:
                _pre_approval_required = "Yes"
            
            _automatic_exit_required = 'No'
            if each_location['automatic_exit_required']:
                _automatic_exit_required = "Yes"

            item = {
                'location_name': each_location['location_name'],
                'parent_location': parent_location,
                'pre_approval_required': _pre_approval_required,
                'automatic_exit_required': _automatic_exit_required, 
                'name':'',
                'entry_no':'',
                'email':'',
                'gender':'',
                'department':'',
                'degree_name':'',
                'hostel':'',
                'room_no':'',
                'year_of_entry':'',
                'mobile_no':'',
                'profile_img':'',
                'degree_duration':'',
                'designation':'',
            }
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
def get_parent_location_name(request):
    try:
        location = request.data['location']
        query_set = Location.objects.get(location_name=location)
        serializer = LocationSerializer(query_set, many=False)
        parent_id = serializer.data['parent_id']
        parent_location = ''
        if parent_id != -1:
            query_set = Location.objects.get(location_id=parent_id)
            serializer = LocationSerializer(query_set, many=False)
            parent_location = serializer.data['location_name']
     
        res = {'parent_location':parent_location}
        return Response(res, status.HTTP_200_OK)
    except Exception as e:
        res = {'parent_location':parent_location}
        return Response(res, status.HTTP_500_INTERNAL_SERVER_ERROR)
        
#################### Guard
@api_view(['POST'])
def get_all_guard_emails(request):
    res=[]
    query_set = Guard.objects.all()
    for each_query_set in query_set:
        serializer = GuardSerializer(each_query_set, many=False)
        _email = serializer.data['email'] 
        is_present = serializer.data['is_present']
        if is_present:
            ResultObj = {'email': _email}
            res.append(ResultObj)
    output = {
        "output": res
    }
    return Response(output, status.HTTP_200_OK)

@api_view(['POST'])
def get_guard_by_email(request):
    data = request.data
    email_ = data['email']

    try:
        queryset = Guard.objects.get(email = email_,is_present=True)
        serializer = GuardSerializer(queryset, many=False)
        
        _location_id = serializer.data['location_id']
        query_set_location = Location.objects.get(location_id =_location_id)
        location_name = LocationSerializer(query_set_location,many=False).data['location_name']

        res={
            'name': serializer.data['guard_name'],
            'email': serializer.data['email'],
            'profile_img': serializer.data['profile_img'],
            'location': location_name
        }
    except:
        res={}
    
    return Response(res)

@api_view(['GET', 'POST'])
def get_all_guards(request):
    res = []
    try:
        queryset = Guard.objects.filter(is_present=True)
        
        serializer = GuardSerializer(queryset, many=True)
        
        for each_guard in serializer.data: 
            
            _location_id = each_guard['location_id']
            
            query_set_location = Location.objects.get(location_id = _location_id)
            
            location_name = LocationSerializer(query_set_location,many=False).data['location_name']
            
            item = {
                'name': each_guard['guard_name'],
                'location_name': location_name,
                'email': each_guard['email'],
                'profile_img': each_guard['profile_img'],                
                'entry_no': '',
                'gender': '',
                'department': '',
                'degree_name': '',
                'hostel': '',
                'room_no': '',
                'year_of_entry': '',
                'mobile_no': '',
                'degree_duration':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
                'designation':'',
            }
            
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

##################### Authoriites
@api_view(['POST'])
def get_authority_by_email(request):   
    try:
        data = request.data
        email_ = data['email']
        queryset = Authorities.objects.get(email = email_,is_present=True)
        serializer = AuthoritiesSerializer(queryset, many=False)
        
        res={
            'name': serializer.data['authority_name'],
            'email': serializer.data['email'],
            'profile_img': serializer.data['profile_img'],
            'designation': serializer.data['authority_designation']
        }
    except:
        res={}
    
    return Response(res)

@api_view(['POST'])
def get_authorities_list(request):
    try:        
        queryset = Authorities.objects.filter(is_present=True)
        serializer = AuthoritiesSerializer(queryset, many=True)
        res = []
        for each_authority in serializer.data:
            if each_authority['authority_name'] == initial_data:
                continue
            obj = {
                'authority_name': each_authority['authority_name'],
                'authority_designation': each_authority['authority_designation'],
                'email': each_authority['email'],
            }          
            res.append(obj)
            
        obj = {
            'authority_name': "None",
            'authority_designation': "None",
            'email': "None",
        }    
        res.append(obj)
        return Response(res, status=status.HTTP_200_OK)    
        
    except Exception as e:
        res = []
        obj = {
            'authority_name': "None",
            'authority_designation': "None",
            'email': "None",
        }    
        res.append(obj)
        return Response(res, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['POST'])
def get_authority_tickets_with_status_accepted(request):
    try:   
        data = request.data
        
        email = data['email']     
        
        location = data['location']    
        
        ticket_type = data['ticket_type']
        
        queryset_student = Student.objects.get(email=email)
        
        queryset_location = Location.objects.get(location_name=location)
        
        queryset_authorities_ticket_table = AuthoritiesTicketTable.objects.filter(
            location_id = queryset_location,
            entry_no = queryset_student,
            is_approved = "Approved",
            ticket_type = ticket_type,
        )
        print("here2")
        
        serializer = AuthoritiesTicketTableSerializer(queryset_authorities_ticket_table, many=True)
        
        print("here3")        
        
        res = []
        
        for each_ticket in serializer.data:
            
            queryset_auth_id = each_ticket['auth_id']
            
            print("queryset_auth_id")
            print(queryset_auth_id)
            
            queryset_authority = Authorities.objects.get(auth_id = queryset_auth_id)
            
            print("queryset_authority")
            print(queryset_authority)
            
            
            serializer_authority = AuthoritiesSerializer(queryset_authority, many=False)
            
            obj = {
                'authority_name': serializer_authority.data['authority_name'],
                'authority_designation': serializer_authority.data['authority_designation'],
                'student_message': each_ticket['student_message'],
                'authority_message': each_ticket['authority_message'],
                'ref_id': str(each_ticket['ref_id']),
            }          
            res.append(obj)
        
        # obj = {
        #     'authority_name': "None",
        #     'authority_designation': "None",
        #     'student_message': "None",
        #     'authority_message': "None",
        #     'ref_id': "None",
        # }    
        # res.append(obj)
        res.reverse()
        
        return Response(res, status=status.HTTP_200_OK)    
        
    except Exception as e:
        print("Exception: " + str(e))
        res = []
        # obj = {
        #     'authority_name': "None",
        #     'authority_designation': "None",
        #     'student_message': "None",
        #     'authority_message': "None",
        #     'ref_id': "None",
        # }    
        # res.append(obj)
        
        return Response(res, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

########################## Admin
@api_view(['POST'])
def get_admin_by_email(request):
    data = request.data
    email_ = data['email']

    try:
        queryset = Admin.objects.get(email = email_,is_present=True)
        serializer = AdminSerializer(queryset, many=False)
        
        res={
            'name': serializer.data['admin_name'],
            'email': serializer.data['email'],
            'profile_img': serializer.data['profile_img'],
        }
    except:
        res={}
    
    return Response(res)

@api_view(['GET', 'POST'])
def get_all_admins(request):
    res = []
    try:
        queryset = Admin.objects.filter(is_present=True)
        
        serializer = AdminSerializer(queryset, many=True)
        
        for each_admin in serializer.data: 
            
            item = {
                'name': each_admin['admin_name'],
                'email': each_admin['email'],
                'profile_img': each_admin['profile_img'],                
                'entry_no':'',
                'gender':'',
                'department':'',
                'degree_name':'',
                'hostel':'',
                'room_no':'',
                'year_of_entry':'',
                'mobile_no':'',
                'degree_duration':'',
                'location_name':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
                'designation':'',
            }
            
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)
########################### Change Profile Photo
@api_view(['POST'])    
def change_profile_picture_of_student(request):
    try:
        upFile = request.FILES.get("image")
        email = request.data['email']
        
        is_student_present = len(Student.objects.filter(email = email, is_present = True))!=0
        
        if is_student_present:
            student = Student.objects.get(email = email, is_present = True)
            
            ext = upFile.name.split(".")[-1]

            curr_time = datetime.now()
            custom_name = str(student.entry_no) + "_"+ str(curr_time) +"." + ext
            upFile.name = custom_name
            
            student.profile_img = upFile
            student.save()
            res_str = "Image Updated Sucessfully"
            return Response(res_str, status=status.HTTP_200_OK)
            
        res_str = "Student Not Found"
        return Response(res_str, status=status.HTTP_200_OK)

    except:
        res_str = "Error Occured"
        return Response(res_str, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])    
def change_profile_picture_of_guard(request):
    try:
        upFile = request.FILES.get("image")
        email = request.data['email']
        
        is_guard_present = len(Guard.objects.filter(email = email, is_present = True))!=0
        
        if is_guard_present:
            guard = Guard.objects.get(email = email, is_present = True)
            
            ext = upFile.name.split(".")[-1]

            curr_time = datetime.now()
            custom_name = str(guard.email) + "_"+ str(curr_time) +"." + ext
            upFile.name = custom_name
            
            guard.profile_img = upFile
            guard.save()
            res_str = "Image Updated Sucessfully"
            return Response(res_str, status=status.HTTP_200_OK)
            
        res_str = "Guard Not Found"
        return Response(res_str, status=status.HTTP_200_OK)

    except:
        res_str = "Error Occured"
        return Response(res_str, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])    
def change_profile_picture_of_authority(request):
    try:
        upFile = request.FILES.get("image")
        email = request.data['email']
        
        is_authority_present = len(Authorities.objects.filter(email = email, is_present = True))!=0
        
        if is_authority_present:
            authority = Authorities.objects.get(email = email, is_present = True)
            
            ext = upFile.name.split(".")[-1]

            curr_time = datetime.now()
            custom_name = str(authority.email) + "_"+ str(curr_time) +"." + ext
            upFile.name = custom_name
            
            authority.profile_img = upFile
            authority.save()
            res_str = "Image Updated Sucessfully"
            return Response(res_str, status=status.HTTP_200_OK)
            
        res_str = "Authority Not Found"
        return Response(res_str, status=status.HTTP_200_OK)

    except:
        res_str = "Error Occured"
        return Response(res_str, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])    
def change_profile_picture_of_admin(request):
    try:
        upFile = request.FILES.get("image")
        email = request.data['email']
        
        is_admin_present = len(Admin.objects.filter(email = email, is_present = True))!=0
        
        if is_admin_present:
            admin = Admin.objects.get(email = email, is_present = True)
            
            ext = upFile.name.split(".")[-1]

            curr_time = datetime.now()
            custom_name = str(admin.email) + "_"+ str(curr_time) +"." + ext
            upFile.name = custom_name
            
            admin.profile_img = upFile
            admin.save()
            res_str = "Image Updated Sucessfully"
            return Response(res_str, status=status.HTTP_200_OK)
            
        res_str = "Admin Not Found"
        return Response(res_str, status=status.HTTP_200_OK)

    except:
        res_str = "Error Occured"
        return Response(res_str, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


################# Hostel
@api_view(['GET','POST'])
def get_all_hostels(request):
    res = []
    try:
        queryset = Hostel.objects.filter(is_present=True)
        
        serializer = HostelSerializer(queryset, many=True)
        
        for each_hostel in serializer.data: 
            if each_hostel['hostel_name'] == initial_data:
                continue
            item = {
                'hostel': each_hostel['hostel_name'],
                
                'name':'',
                'entry_no':'',
                'email':'',
                'gender':'',
                'department':'',
                'degree_name':'',
                'room_no':'',
                'year_of_entry':'',
                'mobile_no':'',
                'profile_img':'',
                'degree_duration':'',
                'location_name':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
                'designation':'',
            }
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

################# Authorities
@api_view(['GET','POST'])
def get_all_authorites(request):
    res = []
    try:
        queryset = Authorities.objects.filter(is_present=True)
        
        serializer = AuthoritiesSerializer(queryset, many=True)
        
        for each_authority in serializer.data: 
            if each_authority['authority_name'] == initial_data:
                continue
            item = {
                'name': each_authority['authority_name'],
                'designation': each_authority['authority_designation'],
                'email': each_authority['email'],
                
                'entry_no':'',
                'gender':'',
                'department':'',
                'degree_name':'',
                'hostel':'',
                'room_no':'',
                'year_of_entry':'',
                'mobile_no':'',
                'profile_img':'',
                'degree_duration':'',
                'location_name':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
            }
            
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

################# Department
@api_view(['GET','POST'])
def get_all_departments(request):
    res = []
    try:
        queryset = Department.objects.filter(is_present=True)
        
        serializer = DepartmentSerializer(queryset, many=True)
        
        for each_department in serializer.data: 
            if each_department['dept_name'] == initial_data:
                continue
            item = {
                'department': each_department['dept_name'],
                
                'name':'',
                'entry_no':'',
                'email':'',
                'gender':'',
                'degree_name':'',
                'hostel':'',
                'room_no':'',
                'year_of_entry':'',
                'mobile_no':'',
                'profile_img':'',
                'degree_duration':'',
                'location_name':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
                'designation':'',
            }
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

################# Programs
@api_view(['GET','POST'])
def get_all_programs(request):
    res = []
    try:
        queryset = Program.objects.filter(is_present=True)
        
        serializer = ProgramSerializer(queryset, many=True)
        
        for each_program in serializer.data: 
            if each_program['degree_name'] == initial_data:
                continue
            item = {
                'degree_name': each_program['degree_name'],
                'degree_duration': str(each_program['degree_duration']),
                
                'name':'',
                'entry_no':'',
                'email':'',
                'gender':'',
                'department':'',
                'hostel':'',
                'room_no':'',
                'year_of_entry':'',
                'mobile_no':'',
                'profile_img':'',
                'location_name':'',
                'parent_location':'',
                'pre_approval_required':'',
                'automatic_exit_required':'',
                'designation':'',
            }
            res.append(item)
        return Response({"output": res}, status= status.HTTP_200_OK)
    except:
        return Response(status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET','POST'])
def insert_in_visitors_ticket_table(request):
    res = {}
    try:
        visitor_name = request.data['visitor_name']
        mobile_no = request.data['mobile_no']
        car_number = request.data['car_number']
        authority_name = request.data['authority_name']
        authority_email = request.data['authority_email']
        authority_designation = request.data['authority_designation']
        purpose = request.data['purpose']
        ticket_type = request.data['ticket_type']
        duration_of_stay = request.data['duration_of_stay']
        
        is_not_present = len(Visitor.objects.filter(visitor_name = visitor_name, mobile_no = mobile_no)) == 0
            
        if is_not_present:
            Visitor.objects.create(visitor_name = visitor_name, mobile_no = mobile_no)
        
        queryset_visitor = Visitor.objects.get(visitor_name = visitor_name, mobile_no = mobile_no)
        
        serializer_visitor = VisitorSerializer(queryset_visitor, many=False)
        
        current_status = serializer_visitor.data['current_status']
        
        if ticket_type == 'enter' and current_status in ['pending_exit','in']:
            print('Cannot raise an entry ticket because person is already inside campus')
            res["status"] = True
            res["message"] = 'Cannot raise an entry ticket because person is already inside campus'
            return Response({"output": res}, status= status.HTTP_400_BAD_REQUEST)
        
        if ticket_type == 'exit' and current_status in ['pending_entry', 'out']:
            print('Cannot raise an exit ticket because person is already outside campus')
            res["status"] = True
            res["message"] = 'Cannot raise an exit ticket because person is already outside campus'
            return Response({"output": res}, status= status.HTTP_400_BAD_REQUEST)
        
        is_authority_present = len(Authorities.objects.filter(email = authority_email, is_present = True))!=0
        
        if is_authority_present:
            queryset_authority = Authorities.objects.get(email = authority_email, is_present = True)
        
        else:
            print('Requested authority is not present')
            res["status"] = True
            res["message"] = 'Requested authority is not present'
            return Response({"output": res}, status= status.HTTP_400_BAD_REQUEST)
        
        VisitorTicketTable.objects.create(
            visitor_id = queryset_visitor,
            car_number = car_number,
            auth_id = queryset_authority,
            purpose = purpose,
            ticket_type = ticket_type,
            duration_of_stay = duration_of_stay,
        )
        
        Visitor.objects.filter(visitor_name = visitor_name, mobile_no = mobile_no).update(current_status = 'pending_entry')
        
        res["status"] = True
        res["message"] = "Ticket inserted in visitors table successfully"
        return Response({"output": res}, status= status.HTTP_200_OK)
    
    except:           
        res["status"] = False
        res["message"] = "Exception in inserting ticket to visitors table"
        return Response({"output": res}, status= status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET','POST'])
def insert_in_visitors_ticket_table_2(request):
    res = {}
    try:
        authority_status = request.data['authority_status']
        visitor_ticket_id = int(request.data['visitor_ticket_id'])
        authority_message = request.data['authority_message']
        
        VisitorTicketTable.objects.filter(visitor_ticket_id = visitor_ticket_id).update(
            authority_status = authority_status, 
            authority_message = authority_message,
            date_time_authority = datetime.now(),
        )
        
        res["status"] = True
        res["message"] = "Authority status of visitor ticket updated"
        return Response({"output": res}, status= status.HTTP_200_OK)
    
    except:           
        res["status"] = False
        res["message"] = "Exception in insert_in_visitors_ticket_table_2"
        return Response({"output": res}, status= status.HTTP_500_INTERNAL_SERVER_ERROR)

################# Student
@api_view(['POST'])
def get_status_for_all_locations(request):
    res = {}
    try:
        _email = request.data['email']

        queryset_student = Student.objects.get(email = _email)
        queryset_student_serializer = StudentSerializer(queryset_student, many=False)
        _entry_no = queryset_student_serializer.data['entry_no']
        
        queryset_status_table = StatusTable.objects.filter(entry_no = _entry_no)
        for each_query_set in queryset_status_table:
            queryset_status_table_serializer = StatusTableSerializer(each_query_set, many=False)
            _status = queryset_status_table_serializer.data['current_status']
            _location_id = queryset_status_table_serializer.data['location_id']
            
            queryset_location = Location.objects.get(location_id = _location_id)
            queryset_location_serializer = LocationSerializer(queryset_location,many=False)
            _location_name = queryset_location_serializer.data['location_name']
            res[_location_name] = _status

        return Response(res, status = status.HTTP_200_OK)


    
    except Exception as e:
        print("Exception Occured in get_status_for_all_locations function")
        print(e)
        res_str = "Error Occured"
        return Response(res_str, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
