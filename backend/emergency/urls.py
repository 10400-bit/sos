from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('register/', views.register, name='register'),
    path('qr/<uuid:user_id>/', views.view_qr, name='view_qr'),
    path('qr-scans/', views.qr_scans, name='qr_scans'),
    path('alerts/', views.alerts, name='alerts'),
    path('emergency/report/', views.report_emergency, name='report_emergency'),
    path('api/scan-qr/', views.scan_qr, name='scan_qr'),
]

