#include "backend.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
{
}

QString BackEnd::userName()
{
    return m_userName;
}

void BackEnd::setUserName(const QString &userName)
{
    if (userName == m_userName)
        return;

    m_userName = userName;
    emit userNameChanged();
}

//--- возвращает строку из файла с куки
QString BackEnd::getCookie()
{

    std::ifstream infile("./cookies.cks");
    QString res;
    std::string str;
    while (std::getline(infile, str))
    {
        res = QString::fromUtf8(str.c_str());
    }


    return res;
}


//--- перезаписывает строку куки в файле
void BackEnd::setCookie(const QString &getCookie)
{

    std::ofstream out("./cookies.cks");
    out <<  getCookie.toUtf8().constData();
    out.close();


    emit cookieChanged();
}
