from django.urls import path
from api.views import * 

# http://localhost:8000/students/add_authorities_from_file
# http://localhost:8000/students/delete_authorities_from_file

urlpatterns = [
    #################### Login
    path('login_user',login_user),
    path('forgot_password',forgot_password),
    path('reset_password',reset_password),
    path('get_welcome_message',get_welcome_message),
    
    ################### Init and clear DB
    path('init_db',init_db),
    path('clear_db',clear_db),

    ############## add data from files routes 
    path('files/add_departments_from_file',add_departments_from_file),
    path('files/add_programs_from_file',add_programs_from_file),
    path('files/add_hostels_from_file',add_hostels_from_file),
    path('files/add_locations_from_file',add_locations_from_file),
    path('files/add_authorities_from_file',add_authorities_from_file),
    path('files/add_guards_from_file',add_guards_from_file),
    path('files/add_students_from_file',add_students_from_file),

    ############## delete data from files routes 
    path('files/delete_departments_from_file',delete_departments_from_file),
    path('files/delete_programs_from_file',delete_programs_from_file),
    path('files/delete_hostels_from_file',delete_hostels_from_file),
    path('files/delete_locations_from_file',delete_locations_from_file),
    path('files/delete_authorities_from_file',delete_authorities_from_file),
    path('files/delete_guards_from_file',delete_guards_from_file),
    path('files/delete_students_from_file',delete_students_from_file),

    ################ add data using forms
    path('forms/add_guard_form',add_guard_form),
    path('forms/add_admin_form',add_admin_form),
    
    ################ modify data using forms
    path('forms/modify_guard_form',modify_guard_form),

    ################ delete data using forms
    path('forms/delete_guard_form',delete_guard_form),

    ################## Students
    path('students/get_students',get_students),
    path('students/get_all_students',get_all_students),
    path('students/add_student',add_student),    
    path('students/get_tickets_for_student', get_tickets_for_student),    
    path('students/get_student_status', get_student_status),    
    path('students/get_student_by_email',get_student_by_email),
    path('students/get_authority_tickets_for_students',get_authority_tickets_for_students), 
    path('students/change_profile_picture_of_student',change_profile_picture_of_student), 
    path('students/get_status_for_all_locations',get_status_for_all_locations), 

    
    ############# Locations
    path('locations/add_new_location',add_new_location),
    path('locations/modify_locations',modify_locations),
    path('locations/delete_location',delete_location),
    path('locations/get_all_locations',get_all_locations), # only fetches location and pre_approval field
    path('locations/view_all_locations',view_all_locations), # fetches all the locations
    path('locations/get_parent_location_name',get_parent_location_name),

    ############# Guards
    path('guards/get_all_guard_emails',get_all_guard_emails),
    path('guards/insert_in_guard_ticket_table', insert_in_guard_ticket_table),
    path('guards/accept_selected_tickets',accept_selected_tickets),
    path('guards/reject_selected_tickets',reject_selected_tickets),
    path('guards/get_pending_tickets_for_guard', get_pending_tickets_for_guard), # To find "Pending" tickets for given location
    path('guards/get_tickets_for_guard', get_tickets_for_guard), # To find "Accepted"|"Rejected" tickets for given location
    path('guards/get_guard_by_email', get_guard_by_email), # To find "Accepted"|"Rejected" tickets for given location
    path('guards/get_list_of_entry_numbers', get_list_of_entry_numbers), 
    
    
    path('guards/change_profile_picture_of_guard', change_profile_picture_of_guard), 
    path('guards/get_all_guards', get_all_guards), 
    
    ############# Visitors
    path('visitors/insert_in_visitors_ticket_table',insert_in_visitors_ticket_table),
    path('visitors/insert_in_visitors_ticket_table_2',insert_in_visitors_ticket_table_2),
    path('visitors/get_list_of_visitors',get_list_of_visitors),
    path('visitors/get_pending_tickets_for_visitors',get_pending_tickets_for_visitors),
    path('visitors/get_pending_visitor_tickets_for_authorities',get_pending_visitor_tickets_for_authorities),
    path('visitors/get_past_visitor_tickets_for_authorities',get_past_visitor_tickets_for_authorities),
    path('visitors/accept_selected_tickets_visitors',accept_selected_tickets_visitors),
    path('visitors/reject_selected_tickets_visitors',reject_selected_tickets_visitors),
    
    
    
    
    
    
       
    ############# Authorities    
    path('authorities/accept_selected_tickets_authorities',accept_selected_tickets_authorities),
    path('authorities/reject_selected_tickets_authorities',reject_selected_tickets_authorities),
    path('authorities/get_pending_tickets_for_authorities', get_pending_tickets_for_authorities), # To find "Pending" tickets for given authority email
    path('authorities/get_tickets_for_authorities', get_tickets_for_authorities), # To find "Accepted"|"Rejected" tickets for given authority email
    path('authorities/get_authority_by_email', get_authority_by_email), 
    path('authorities/get_authorities_list', get_authorities_list), 
    path('authorities/insert_in_authorities_ticket_table', insert_in_authorities_ticket_table),
    path('authorities/get_authority_tickets_with_status_accepted', get_authority_tickets_with_status_accepted),
    
    path('authorities/change_profile_picture_of_authority', change_profile_picture_of_authority),
    path('authorities/get_all_authorites', get_all_authorites),
    
    path('authorities/get_list_of_entry_numbers', get_list_of_entry_numbers), 
    ################# Admin
    path('admins/get_admin_by_email', get_admin_by_email), # To find "Accepted"|"Rejected" tickets for given authority email
    path('admins/change_profile_picture_of_admin', change_profile_picture_of_admin), # To find "Accepted"|"Rejected" tickets for given authority email
    path('admins/get_all_admins', get_all_admins), # Get the list of all admins

    ############ Statistics
    path('statistics/get_statistics_data_by_location',get_statistics_data_by_location),
    path('statistics/get_piechart_statistics_by_location',get_piechart_statistics_by_location),

    ################## Hostel
    path('hostels/get_all_hostels',get_all_hostels),

    ################## Department
    path('departments/get_all_departments',get_all_departments),

    ################## Program
    path('programs/get_all_programs',get_all_programs),
    
    
    ################ This should be at the last
    # path('',thread_functions),


]


