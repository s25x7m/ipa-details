# دليل التثبيت - عارض تفاصيل IPA

تعليمات التثبيت الكاملة لعارض تفاصيل IPA على نظام macOS.

## المتطلبات الأساسية

- macOS 11.0 أو أحدث
- معالج Apple Silicon (M1/M2/M3/M4) أو Intel Mac
- الوصول إلى Terminal

## خطوات التثبيت

### 1. استنساخ المستودع

```bash
git clone https://github.com/x7mii/ipa-details.git
cd ipa-details
```

### 2. تشغيل سكريبت التثبيت

```bash
chmod +x install.sh
./install.sh
```

### 3. ماذا يفعل المثبت

سيقوم سكريبت التثبيت تلقائيًا بـ:

- ✅ إنشاء "IPA Details.app" في `/Applications`
- ✅ نسخ سكريبتات المعاينة إلى حزمة التطبيق
- ✅ تكوين ارتباطات أنواع الملفات لـ `.ipa` و `.mobileprovision` و `.provisionprofile` و `.app`
- ✅ تسجيل التطبيق مع خدمات الإطلاق في macOS
- ✅ تعيين الأذونات المناسبة

### 4. التحقق من التثبيت

بعد اكتمال التثبيت، يجب أن ترى:

```
✅ Installation complete!

📖 Usage:
   1. Right-click any .ipa, .mobileprovision, or .app file
   2. Choose 'Open With' → 'IPA Details'
   3. Preview opens in your browser

💡 To set as default viewer:
   Right-click → Get Info → Open with: IPA Details → Change All...
```

## طرق الاستخدام

### الطريقة 1: قائمة النقر بالزر الأيمن (موصى بها)

1. انتقل إلى أي ملف `.ipa` أو `.mobileprovision` أو `.app` في Finder
2. انقر بزر الماوس الأيمن (أو Control+click) على الملف
3. اختر **فتح بواسطة** → **IPA Details**
4. ستفتح المعاينة في متصفح الويب الافتراضي

### الطريقة 2: التعيين كعارض افتراضي

لجعل IPA Details التطبيق الافتراضي لملفات IPA:

1. انقر بزر الماوس الأيمن على أي ملف `.ipa`
2. اختر **الحصول على معلومات** (⌘+I)
3. في قسم "فتح بواسطة:"، اختر **IPA Details**
4. انقر على **تغيير الكل...** لتطبيقه على جميع ملفات IPA
5. أكد التغيير

### الطريقة 3: النقر المزدوج

بمجرد تعيينه كعارض افتراضي، ببساطة انقر نقرًا مزدوجًا على أي ملف مدعوم لفتحه باستخدام IPA Details.

## استكشاف الأخطاء وإصلاحها

### التطبيق لا يظهر في قائمة "فتح بواسطة"

إذا لم يظهر IPA Details في قائمة "فتح بواسطة":

```bash
# إعادة تسجيل التطبيق
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "/Applications/IPA Details.app"

# إعادة تشغيل Finder
killall Finder
```

### المعاينة لا تفتح

إذا لم تفتح المعاينة في متصفحك:

1. تحقق من أن السكريبتات لديها أذونات التنفيذ:
```bash
ls -la "/Applications/IPA Details.app/Contents/MacOS/"
```

2. أعد تشغيل سكريبت التثبيت:
```bash
./install.sh
```

### أخطاء في الأذونات

إذا واجهت أخطاء في الأذونات أثناء التثبيت:

```bash
# أضف sudo إلى أمر التثبيت
sudo ./install.sh
```

### أخطاء السكريبت غير موجود

تأكد من أنك تقوم بتشغيل التثبيت من الدليل الصحيح:

```bash
# انتقل إلى دليل المشروع
cd /path/to/ipa-details

# تحقق من وجود الملفات
ls -la install.sh ipa-preview provision-preview.sh

# تشغيل التثبيت
./install.sh
```

## إلغاء التثبيت

لإزالة IPA Details بالكامل من نظامك:

```bash
# إزالة التطبيق
sudo rm -rf "/Applications/IPA Details.app"

# إلغاء التسجيل من خدمات الإطلاق
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "/Applications/IPA Details.app"

# إعادة تشغيل Finder
killall Finder
```

## التثبيت اليدوي (متقدم)

إذا كنت تفضل التثبيت يدويًا:

1. إنشاء حزمة التطبيق:
```bash
mkdir -p "/Applications/IPA Details.app/Contents/MacOS"
mkdir -p "/Applications/IPA Details.app/Contents/Resources"
```

2. نسخ السكريبتات:
```bash
cp ipa-preview "/Applications/IPA Details.app/Contents/MacOS/"
cp provision-preview.sh "/Applications/IPA Details.app/Contents/MacOS/"
chmod +x "/Applications/IPA Details.app/Contents/MacOS/ipa-preview"
chmod +x "/Applications/IPA Details.app/Contents/MacOS/provision-preview.sh"
```

3. إنشاء Info.plist (راجع install.sh للحصول على محتوى plist الكامل)

4. إنشاء وترجمة مشغل AppleScript (راجع install.sh للحصول على التفاصيل)

5. التسجيل مع خدمات الإطلاق:
```bash
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "/Applications/IPA Details.app"
```

## متطلبات النظام

- **نظام التشغيل**: macOS 11.0 (Big Sur) أو أحدث
- **البنية**: Apple Silicon أو Intel (عام)
- **مساحة القرص**: ~50 كيلوبايت للتطبيق
- **التبعيات**: جميع الأدوات المطلوبة مدمجة في macOS:
  - `security` - لفك تشفير CMS وتحليل الشهادات
  - `defaults` / `PlistBuddy` - لتحليل plist
  - `openssl` - لتفاصيل الشهادة
  - `python3` - لتنسيق JSON
  - `unzip` - لاستخراج IPA

## الأمان والخصوصية

- **لا يوجد وصول إلى الشبكة**: تتم جميع المعالجة محليًا
- **لا يوجد جمع بيانات**: لا يتم تحميل ملفاتك أو مشاركتها أبدًا
- **للقراءة فقط**: التطبيق يقرأ الملفات فقط، لا يعدلها أبدًا
- **متوافق مع SIP**: يعمل بدون تعطيل System Integrity Protection
- **تنفيذ معزول**: تعمل السكريبتات في أدلة مؤقتة معزولة

## الدعم

للمشاكل أو الأخطاء أو طلبات الميزات:
- افتح مشكلة على [GitHub](https://github.com/x7mii/ipa-details/issues)
- تحقق من المشاكل الموجودة للحلول
- قدم رسائل خطأ مفصلة ومعلومات النظام

---

**صنع بواسطة x7mii** 🚀
