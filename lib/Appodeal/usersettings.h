#ifndef USERSETTINGS_H
#define USERSETTINGS_H

class QAndroidJniObject;

class UserSettings
{
public:
    UserSettings();
    enum class Gender {
        FEMALE, MALE, OTHER
    };
    enum class Occupation {
        WORK, UNIVERSITY, SCHOOL, OTHER
    };
    enum class Relation {
        DATING, ENGAGED, MARRIED, SEARCHING, SINGLE, OTHER
    };
    enum class Alcohol {
        NEGATIVE, NEUTRAL, POSITIVE
    };
    enum class Smoking {
        NEGATIVE, NEUTRAL, POSITIVE
    };

    virtual ~UserSettings();
    virtual void setAge (const int& age);
    virtual void setBirthday (const QString& day);
    virtual void setEmail (const QString& email);
    virtual void setGender (const Gender& gender);
    virtual void setInterests (const QString& interests);
    virtual void setOccupation (const Occupation& occupation);
    virtual void setRelation (const Relation& relation);
    virtual void setAlcohol (const Alcohol& alcohol);
    virtual void setSmoking (const Smoking& smoking);
private:
    QAndroidJniObject* m_userSettings;

};

#endif // USERSETTINGS_H
