from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponse, FileResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from django.utils import timezone
import json
import qrcode
from PIL import Image
import os
from django.conf import settings
from .models import User, QRScan, EmergencyAlert


def index(request):
    """Main dashboard"""
    recent_alerts = EmergencyAlert.objects.all()[:10]
    total_users = User.objects.count()
    total_alerts = EmergencyAlert.objects.count()
    pending_alerts = EmergencyAlert.objects.filter(status='pending').count()
    
    context = {
        'recent_alerts': recent_alerts,
        'total_users': total_users,
        'total_alerts': total_alerts,
        'pending_alerts': pending_alerts,
    }
    return render(request, 'emergency/dashboard.html', context)


def register(request):
    """User registration page"""
    if request.method == 'POST':
        # Check if it's an API request (JSON)
        if request.content_type == 'application/json':
            try:
                data = json.loads(request.body)
                name = data.get('name')
                phone = data.get('phone')
                blood_group = data.get('blood_group')
                emergency_contact_1 = data.get('emergency_contact_1')
                emergency_contact_2 = data.get('emergency_contact_2', '')
                vehicle_number = data.get('vehicle_number')
            except:
                return JsonResponse({'error': 'Invalid JSON'}, status=400)
        else:
            # Form submission
            name = request.POST.get('name')
            phone = request.POST.get('phone')
            blood_group = request.POST.get('blood_group')
            emergency_contact_1 = request.POST.get('emergency_contact_1')
            emergency_contact_2 = request.POST.get('emergency_contact_2', '')
            vehicle_number = request.POST.get('vehicle_number')
        
        # Create user
        user = User.objects.create(
            name=name,
            phone=phone,
            blood_group=blood_group,
            emergency_contact_1=emergency_contact_1,
            emergency_contact_2=emergency_contact_2,
            vehicle_number=vehicle_number
        )
        
        # Generate QR code
        qr_data = {
            'user_id': str(user.id),
            'name': user.name,
            'phone': user.phone,
            'blood_group': user.blood_group,
            'vehicle_number': user.vehicle_number,
        }
        
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(json.dumps(qr_data))
        qr.make(fit=True)
        
        img = qr.make_image(fill_color="black", back_color="white")
        qr_filename = f"qr_{user.id}.png"
        qr_path = os.path.join(settings.QR_CODES_DIR, qr_filename)
        img.save(qr_path)
        
        user.qr_code_path = qr_path
        user.save()
        
        # Return JSON for API requests
        if request.content_type == 'application/json':
            return JsonResponse({
                'success': True,
                'user_id': str(user.id),
                'name': user.name,
                'phone': user.phone,
                'blood_group': user.blood_group,
                'vehicle_number': user.vehicle_number,
            })
        
        return redirect('view_qr', user_id=user.id)
    
    return render(request, 'emergency/register.html')


def view_qr(request, user_id):
    """View QR code for a user"""
    user = get_object_or_404(User, id=user_id)
    
    # Serve QR code image if requested
    if request.GET.get('image') == 'true' and user.qr_code_path:
        if os.path.exists(user.qr_code_path):
            return FileResponse(
                open(user.qr_code_path, 'rb'),
                content_type='image/png',
                filename=f'qr_{user.id}.png'
            )
    
    return render(request, 'emergency/view_qr.html', {'user': user})


def qr_scans(request):
    """View all QR code scans"""
    scans = QRScan.objects.all().order_by('-scanned_at')[:50]
    return render(request, 'emergency/qr_scans.html', {'scans': scans})


def alerts(request):
    """View all emergency alerts"""
    alerts_list = EmergencyAlert.objects.all().order_by('-timestamp')
    return render(request, 'emergency/alerts.html', {'alerts': alerts_list})


@csrf_exempt
@require_http_methods(["POST"])
def report_emergency(request):
    """API endpoint for mobile app to report emergencies"""
    try:
        data = json.loads(request.body)
        
        user_id = data.get('user_id')
        emergency_type = data.get('type', 'accident')
        gps = data.get('gps', '')
        severity = data.get('severity', 'high')
        description = data.get('description', '')
        
        # Parse GPS coordinates
        if gps:
            try:
                lat, lon = map(float, gps.split(','))
            except:
                lat, lon = 0.0, 0.0
        else:
            lat, lon = 0.0, 0.0
        
        # Get or create user
        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
        
        # Create emergency alert
        alert = EmergencyAlert.objects.create(
            user=user,
            emergency_type=emergency_type,
            severity=severity,
            gps_latitude=lat,
            gps_longitude=lon,
            description=description,
        )
        
        return JsonResponse({
            'success': True,
            'alert_id': str(alert.id),
            'message': 'Emergency reported successfully'
        })
    
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)


@csrf_exempt
@require_http_methods(["POST"])
def scan_qr(request):
    """API endpoint for QR code scanning"""
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        scanner_info = data.get('scanner_info', '')
        
        user = get_object_or_404(User, id=user_id)
        
        QRScan.objects.create(
            user=user,
            scanner_info=scanner_info
        )
        
        return JsonResponse({
            'success': True,
            'user': {
                'name': user.name,
                'phone': user.phone,
                'blood_group': user.blood_group,
                'vehicle_number': user.vehicle_number,
                'emergency_contact_1': user.emergency_contact_1,
                'emergency_contact_2': user.emergency_contact_2,
            }
        })
    
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)

