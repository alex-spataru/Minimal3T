#if (__ANDROID_API__ >= 9)

#include "QAndroidJniObject"
#include <QPA/QPlatformNativeInterface.h>
#include <QApplication>
#include "usersettings.h"

UserSettings::UserSettings()
    : m_userSettings (0)
{
    QPlatformNativeInterface* interface = QApplication::platformNativeInterface();
    jobject activity = (jobject)interface->nativeResourceForIntegration ("QtActivity");
    if (activity)
        m_userSettings = new QAndroidJniObject (activity);

}

UserSettings::~UserSettings()
{
    if (m_userSettings)
        delete m_userSettings;
}

void UserSettings::setAge (const int& age)
{
    m_userSettings->callMethod<void> ("setAge", "(I)V", age);
}

void UserSettings::setBirthday (const QString& day)
{
    QAndroidJniObject dayS = QAndroidJniObject::fromString (day);
    m_userSettings->callMethod<void> ("setBirthday", "(Ljava/lang/String;)V", dayS.object<jstring>() );
}

void UserSettings::setEmail (const QString& email)
{
    QAndroidJniObject emailS = QAndroidJniObject::fromString (email);
    m_userSettings->callMethod<void> ("setEmail", "(Ljava/lang/String;)V", emailS.object<jstring>() );
}

void UserSettings::setFacebookId (const QString& facebookId)
{
    QAndroidJniObject facebookIdS = QAndroidJniObject::fromString (facebookId);
    m_userSettings->callMethod<void> ("setFacebookId", "(Ljava/lang/String;)V",
                                      facebookIdS.object<jstring>() );
}

void UserSettings::setVkId (const QString& vkId)
{
    QAndroidJniObject vkIdS = QAndroidJniObject::fromString (vkId);
    m_userSettings->callMethod<void> ("setVkId", "(Ljava/lang/String;)V", vkIdS.object<jstring>() );
}

void UserSettings::setGender (const Gender& gender)
{
    m_userSettings->callMethod<void> ("setGender", "(I)V",  gender);
}

void UserSettings::setInterests (const QString& interests)
{
    QAndroidJniObject interestsS = QAndroidJniObject::fromString (interests);
    m_userSettings->callMethod<void> ("setInterests", "(Ljava/lang/String;)V",
                                      interestsS.object<jstring>() );
}

void UserSettings::setOccupation (const Occupation& occupation)
{
    m_userSettings->callMethod<void> ("setOccupation", "(I)V",  occupation);
}
void UserSettings::setRelation (const Relation& relation)
{
    m_userSettings->callMethod<void> ("setRelation", "(I)V",  relation);
}

void UserSettings::setAlcohol (const Alcohol& alcohol)
{
    m_userSettings->callMethod<void> ("setAlcohol", "(I)V",  alcohol);
}

void UserSettings::setSmoking (const Smoking& smoking)
{
    m_userSettings->callMethod<void> ("setSmoking", "(I)V",  smoking);
}

#endif
