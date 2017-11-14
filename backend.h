#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>

class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString getCookie READ getCookie WRITE setCookie NOTIFY cookieChanged)

public:
    explicit BackEnd(QObject *parent = nullptr);

    QString userName();
    QString getCookie();
    void setUserName(const QString &userName);
    void setCookie(const QString &userName);

signals:
    void userNameChanged();
    void cookieChanged();

private:
    QString m_userName;
};

#endif // BACKEND_H
