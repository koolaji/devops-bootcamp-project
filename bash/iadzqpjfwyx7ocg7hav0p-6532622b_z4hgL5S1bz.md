# DevOps Bash Database Assignment
## تکلیف بش اسکریپت و پایگاه داده دوآپس

---

## 📋 Assignment Overview | خلاصه تکلیف

**English**: Create 3 bash scripts to work with MySQL database - import data, generate reports, and manage CSV files.

**فارسی**: سه اسکریپت بش برای کار با پایگاه داده MySQL بنویسید - وارد کردن داده، تولید گزارش، و مدیریت فایل‌های CSV.

---

## 🎯 Tasks | وظایف

### Task 1: Database Import Script | وظیفه ۱: اسکریپت وارد کردن پایگاه داده
**File**: `import_db.sh`

**English**:
- Import the SQL file to MySQL database
- Create database connection
- Handle errors if import fails
- Show success/failure message

**فارسی**:
- فایل SQL را به پایگاه داده MySQL وارد کنید
- اتصال به پایگاه داده برقرار کنید
- خطاها را در صورت شکست واردات مدیریت کنید
- پیام موفقیت/شکست نمایش دهید

### Task 2: Report Generator Script | وظیفه ۲: اسکریپت تولید گزارش
**File**: `generate_report.sh`

**English**:
- Connect to database
- Query employee data
- Export results to CSV file
- Include columns: employee_id, name, department, salary, status

**فارسی**:
- به پایگاه داده متصل شوید
- داده‌های کارمندان را جستجو کنید
- نتایج را به فایل CSV صادر کنید
- ستون‌ها شامل: شناسه کارمند، نام، بخش، حقوق، وضعیت

### Task 3: CSV Import Script | وظیفه ۳: اسکریپت وارد کردن CSV
**File**: `import_csv.sh`

**English**:
- Read CSV file from Task 2
- Create new table called `employee_reports`
- Import CSV data to new table
- Verify import was successful

**فارسی**:
- فایل CSV از وظیفه ۲ را بخوانید
- جدول جدیدی به نام `employee_reports` ایجاد کنید
- داده‌های CSV را به جدول جدید وارد کنید
- موفقیت واردات را تأیید کنید

---

## 🛠️ Prerequisites | پیش‌نیازها

**English**:
- MySQL installed and running
- Bash shell access
- Basic knowledge of SQL commands
- Text editor (nano, vim, or VS Code)

**فارسی**:
- MySQL نصب و در حال اجرا باشد
- دسترسی به پوسته بش
- دانش پایه دستورات SQL
- ویرایشگر متن (nano، vim، یا VS Code)

---

## 📁 File Structure | ساختار فایل‌ها

```
homework/
├── import_db.sh           # Database import script | اسکریپت وارد کردن پایگاه داده
├── generate_report.sh     # Report generator | تولیدکننده گزارش
├── import_csv.sh          # CSV import script | اسکریپت وارد کردن CSV
├── homework_bash.sql      # Database file | فایل پایگاه داده
├── employee_report.csv    # Generated report | گزارش تولید شده
└── README.md              # This file | این فایل
```

---

## 🚀 Getting Started | شروع کار

### Step 1: Setup | مرحله ۱: راه‌اندازی

**English**:
1. Download all files to your working directory
2. Make scripts executable: `chmod +x *.sh`
3. Ensure MySQL is running: `sudo systemctl start mysql`

**فارسی**:
1. تمام فایل‌ها را در دایرکتوری کاری خود دانلود کنید
2. اسکریپت‌ها را قابل اجرا کنید: `chmod +x *.sh`
3. اطمینان حاصل کنید MySQL در حال اجرا است: `sudo systemctl start mysql`

### Step 2: Run Scripts | مرحله ۲: اجرای اسکریپت‌ها

**English**:
```bash
# 1. Import database
./import_db.sh

# 2. Generate report
./generate_report.sh

# 3. Import CSV to new table
./import_csv.sh
```

**فارسی**:
```bash
# ۱. وارد کردن پایگاه داده
./import_db.sh

# ۲. تولید گزارش
./generate_report.sh

# ۳. وارد کردن CSV به جدول جدید
./import_csv.sh
```

---

## 📋 Script Requirements | الزامات اسکریپت

### import_db.sh Requirements | الزامات import_db.sh

**English**:
- Prompt for MySQL username and password
- Create database if not exists
- Import homework_bash.sql file
- Display success/error messages
- Exit with appropriate code (0 for success, 1 for error)

**فارسی**:
- درخواست نام کاربری و رمز عبور MySQL
- ایجاد پایگاه داده در صورت عدم وجود
- وارد کردن فایل homework_bash.sql
- نمایش پیام‌های موفقیت/خطا
- خروج با کد مناسب (۰ برای موفقیت، ۱ برای خطا)

### generate_report.sh Requirements | الزامات generate_report.sh

**English**:
- Connect to employee_company database
- Query all active employees
- Export to CSV with headers
- Save as employee_report.csv
- Show number of records exported

**فارسی**:
- اتصال به پایگاه داده employee_company
- جستجوی تمام کارمندان فعال
- صادرات به CSV با سرتیتر
- ذخیره به عنوان employee_report.csv
- نمایش تعداد رکوردهای صادر شده

### import_csv.sh Requirements | الزامات import_csv.sh

**English**:
- Read employee_report.csv file
- Create employee_reports table
- Import CSV data to table
- Handle duplicate records
- Display import statistics

**فارسی**:
- خواندن فایل employee_report.csv
- ایجاد جدول employee_reports
- وارد کردن داده‌های CSV به جدول
- مدیریت رکوردهای تکراری
- نمایش آمار واردات

---

## 🔍 Testing Your Scripts | تست اسکریپت‌های شما

**English**:
```bash
# Test database connection
mysql -u your_username -p -e "SHOW DATABASES;"

# Check if data imported correctly
mysql -u your_username -p employee_company -e "SELECT COUNT(*) FROM employees;"

# Verify CSV file created
ls -la employee_report.csv

# Check new table created
mysql -u your_username -p employee_company -e "SHOW TABLES;"
```

**فارسی**:
```bash
# تست اتصال پایگاه داده
mysql -u your_username -p -e "SHOW DATABASES;"

# بررسی صحت واردات داده
mysql -u your_username -p employee_company -e "SELECT COUNT(*) FROM employees;"

# تأیید ایجاد فایل CSV
ls -la employee_report.csv

# بررسی ایجاد جدول جدید
mysql -u your_username -p employee_company -e "SHOW TABLES;"
```

---

## 💡 Helpful Commands | دستورات مفید

### MySQL Commands | دستورات MySQL

**English**:
```sql
-- Show all databases
SHOW DATABASES;

-- Use specific database
USE employee_company;

-- Show all tables
SHOW TABLES;

-- Count records in table
SELECT COUNT(*) FROM employees;

-- Show table structure
DESCRIBE employees;
```

**فارسی**:
```sql
-- نمایش تمام پایگاه‌های داده
SHOW DATABASES;

-- استفاده از پایگاه داده خاص
USE employee_company;

-- نمایش تمام جداول
SHOW TABLES;

-- شمارش رکوردها در جدول
SELECT COUNT(*) FROM employees;

-- نمایش ساختار جدول
DESCRIBE employees;
```

### Bash Commands | دستورات بش

**English**:
```bash
# Make file executable
chmod +x script.sh

# Run script
./script.sh

# Check if file exists
if [ -f "filename" ]; then echo "File exists"; fi

# Read user input
read -p "Enter username: " username
```

**فارسی**:
```bash
# قابل اجرا کردن فایل
chmod +x script.sh

# اجرای اسکریپت
./script.sh

# بررسی وجود فایل
if [ -f "filename" ]; then echo "File exists"; fi

# خواندن ورودی کاربر
read -p "Enter username: " username
```

---

## ❗ Common Issues | مشکلات رایج

### Database Connection Issues | مشکلات اتصال پایگاه داده

**English**:
- **Problem**: "Access denied for user"
- **Solution**: Check username and password, ensure user has proper privileges

**فارسی**:
- **مشکل**: "Access denied for user"
- **راه‌حل**: نام کاربری و رمز عبور را بررسی کنید، اطمینان حاصل کنید کاربر دسترسی‌های لازم را دارد

### File Permission Issues | مشکلات مجوز فایل

**English**:
- **Problem**: "Permission denied"
- **Solution**: Run `chmod +x script.sh` to make script executable

**فارسی**:
- **مشکل**: "Permission denied"
- **راه‌حل**: دستور `chmod +x script.sh` را اجرا کنید تا اسکریپت قابل اجرا شود

### CSV Format Issues | مشکلات فرمت CSV

**English**:
- **Problem**: CSV import fails
- **Solution**: Check CSV format, ensure proper delimiters and encoding

**فارسی**:
- **مشکل**: واردات CSV شکست می‌خورد
- **راه‌حل**: فرمت CSV را بررسی کنید، اطمینان حاصل کنید جداکننده‌ها و کدگذاری صحیح است

---

## 📊 Grading Criteria | معیارهای نمره‌دهی

| Task | Points | English Criteria | معیارهای فارسی |
|------|--------|------------------|----------------|
| **import_db.sh** | 30 | Database import works correctly, error handling | واردات پایگاه داده صحیح کار می‌کند، مدیریت خطا |
| **generate_report.sh** | 35 | CSV export works, proper formatting | صادرات CSV کار می‌کند، فرمت‌بندی صحیح |
| **import_csv.sh** | 25 | CSV import to new table successful | واردات CSV به جدول جدید موفق |
| **Code Quality** | 10 | Comments, error handling, clean code | کامنت‌ها، مدیریت خطا، کد تمیز |
| **Total** | **100** | | |

---

## 🎯 Expected Output | خروجی مورد انتظار

### After running import_db.sh | پس از اجرای import_db.sh
```
✅ Database 'employee_company' created successfully!
✅ Imported 49 employee records
✅ Database setup complete!
```

### After running generate_report.sh | پس از اجرای generate_report.sh
```
✅ Connected to database successfully!
✅ Exported 45 active employees to employee_report.csv
✅ Report generation complete!
```

### After running import_csv.sh | پس از اجرای import_csv.sh
```
✅ Created table 'employee_reports' successfully!
✅ Imported 45 records from CSV file
✅ CSV import complete!
```

---

## 📞 Support | پشتیبانی

**English**: If you encounter any issues, check the common problems section above or contact your instructor.

**فارسی**: اگر با مشکلی مواجه شدید، بخش مشکلات رایج بالا را بررسی کنید یا با مدرس خود تماس بگیرید.

---

## 🏆 Bonus Points | امتیاز اضافی

**English**:
- Add data validation in scripts (+5 points)
- Create backup before import (+3 points)
- Add logging functionality (+2 points)

**فارسی**:
- اعتبارسنجی داده در اسکریپت‌ها (+۵ امتیاز)
- ایجاد پشتیبان قبل از واردات (+۳ امتیاز)
- اضافه کردن قابلیت لاگ (+۲ امتیاز)

---

**Good luck with your assignment! | موفق باشید!** 🚀

---
*Created for DevOps Bootcamp | ایجاد شده برای بوت‌کمپ دوآپس*