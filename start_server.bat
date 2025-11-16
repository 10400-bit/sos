@echo off
echo ========================================
echo Emergency Response System - Starting...
echo ========================================
echo.

cd backend

if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
)

echo Activating virtual environment...
call venv\Scripts\activate

echo Installing dependencies...
pip install -q -r requirements.txt

echo Running migrations...
python manage.py migrate

echo Starting Django server...
echo.
echo Server will be available at:
echo   - Local: http://127.0.0.1:8000
echo   - Network: http://YOUR_IP:8000
echo.
echo To find your IP, run: ipconfig
echo Press Ctrl+C to stop the server
echo.

python manage.py runserver 0.0.0.0:8000

pause

