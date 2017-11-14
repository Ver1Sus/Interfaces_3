#ifndef DECL_H
#define DECL_H


#include <QObject>
#include <QString>

class decl: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)

public:
    decl();
};

#endif // DECL_H
