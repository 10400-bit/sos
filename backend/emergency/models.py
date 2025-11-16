from django.db import models
from django.utils import timezone
import uuid


class User(models.Model):
    """User registration model"""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=200)
    phone = models.CharField(max_length=20)
    blood_group = models.CharField(max_length=10)
    emergency_contact_1 = models.CharField(max_length=20)
    emergency_contact_2 = models.CharField(max_length=20, blank=True, null=True)
    vehicle_number = models.CharField(max_length=50, unique=True)
    qr_code_path = models.CharField(max_length=500, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} - {self.vehicle_number}"


class QRScan(models.Model):
    """QR Code scan logs"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='qr_scans')
    scanned_at = models.DateTimeField(auto_now_add=True)
    scanner_info = models.CharField(max_length=200, blank=True)

    def __str__(self):
        return f"QR Scan - {self.user.name} at {self.scanned_at}"


class EmergencyAlert(models.Model):
    """Emergency alerts received from mobile app"""
    SEVERITY_CHOICES = [
        ('low', 'Low'),
        ('medium', 'Medium'),
        ('high', 'High'),
        ('critical', 'Critical'),
    ]

    EMERGENCY_TYPES = [
        ('accident', 'Accident'),
        ('fire', 'Fire'),
        ('medical', 'Medical'),
        ('criminal', 'Criminal Activity'),
        ('disaster', 'Disaster'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='alerts')
    emergency_type = models.CharField(max_length=20, choices=EMERGENCY_TYPES)
    severity = models.CharField(max_length=20, choices=SEVERITY_CHOICES, default='high')
    gps_latitude = models.DecimalField(max_digits=10, decimal_places=7)
    gps_longitude = models.DecimalField(max_digits=10, decimal_places=7)
    description = models.TextField(blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, default='pending')  # pending, responded, resolved

    class Meta:
        ordering = ['-timestamp']

    def __str__(self):
        return f"{self.emergency_type.upper()} - {self.user.name} at {self.timestamp}"

