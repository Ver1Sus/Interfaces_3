#ifndef KEYGENERATOR_H
#define KEYGENERATOR_H


#include <QObject>
#include <QString>
#include <QStringList>

class KeyGenerator : public QObject
{


public:
    KeyGenerator();
    ~KeyGenerator();

       QString type();
       void setType(const QString &t);

       QStringList types();

       QString filename();
       void setFilename(const QString &f);

       QString passphrase();
       void setPassphrase(const QString &p);

   public slots:
       void generateKey();

   signals:
       void typeChanged();
       void typesChanged();
       void filenameChanged();
       void passphraseChanged();
       void keyGenerated(bool success);

   private:
       QString _type;
       QString _filename;
       QString _passphrase;
       QStringList _types;
   };

#endif // KEYGENERATOR_H
