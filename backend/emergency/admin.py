from django.contrib import admin
from .models import User, QRScan, EmergencyAlert


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['name', 'phone', 'blood_group', 'vehicle_number', 'created_at']
    search_fields = ['name', 'phone', 'vehicle_number']


@admin.register(QRScan)
class QRScanAdmin(admin.ModelAdmin):
    list_display = ['user', 'scanned_at', 'scanner_info']
    list_filter = ['scanned_at']


@admin.register(EmergencyAlert)
class EmergencyAlertAdmin(admin.ModelAdmin):
    list_display = ['user', 'emergency_type', 'severity', 'timestamp', 'status']
    list_filter = ['emergency_type', 'severity', 'status', 'timestamp']
    search_fields = ['user__name', 'user__vehicle_number']

