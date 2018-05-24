#include "googlebookssearchmodel.h"

#include <QUrl>
#include <QUrlQuery>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkAccessManager>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

GoogleBooksSearchModel::GoogleBooksSearchModel(QObject *parent)
    :QAbstractListModel(parent), m_busy(false)
{

}

GoogleBooksSearchModel::~GoogleBooksSearchModel()
{

}

void GoogleBooksSearchModel::setSearchString(const QString &val)
{
    if(m_searchString == val || this->isBusy())
        return;

    m_searchString = val;

    this->beginResetModel();
    m_searchResults = QJsonArray();
    m_maxSearchResultsAvailable = 0;
    this->endResetModel();

    this->doSearch();
    emit searchStringChanged();
}

QString GoogleBooksSearchModel::searchString() const
{
    return m_searchString;
}

int GoogleBooksSearchModel::rowCount(const QModelIndex &parent) const
{
    if(parent.isValid())
        return 0;

    return m_searchResults.size();
}

QVariant GoogleBooksSearchModel::data(const QModelIndex &index,
                                      int role) const
{
    if(!index.isValid())
        return QVariant();

    const QJsonObject bookInfo = m_searchResults.at(index.row()).toObject();
    switch(role)
    {
    case Qt::DisplayRole:
    case Qt::EditRole:
    case TitleRole:
        return bookInfo.value("volumeInfo")
                .toObject().value("title").toString();
    case AuthorsRole:
        return bookInfo.value("volumeInfo")
                .toObject().value("authors").toArray();
    case DescriptionRole:
        return bookInfo.value("volumeInfo")
                .toObject().value("description").toString();
    case ThumbnailRole:
        return bookInfo.value("volumeInfo")
                .toObject().value("imageLinks")
                .toObject().value("thumbnail").toString();
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> GoogleBooksSearchModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[TitleRole] = "bookTitle";
    roles[AuthorsRole] = "bookAuthors";
    roles[DescriptionRole] = "bookDescription";
    roles[ThumbnailRole] = "bookThumbnail";
    roles[SearchResultRole] = "searchResult";
    return roles;
}

void GoogleBooksSearchModel::fetchMore(const QModelIndex &parent)
{
    if(parent.isValid())
        return;

    this->doSearch();
}

bool GoogleBooksSearchModel::canFetchMore(const QModelIndex &parent) const
{
    if(parent.isValid())
        return false;

    return m_searchResults.size() < m_maxSearchResultsAvailable;
}

bool GoogleBooksSearchModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!index.isValid())
        return false;

    if(role != Qt::EditRole)
        return false;

    QJsonObject item = m_searchResults.at(index.row()).toObject();
    QJsonObject volInfo = item.value("volumeInfo").toObject();
    volInfo.insert("title", value.toString());
    item.insert("volumeInfo", volInfo);
    m_searchResults.replace(index.row(), item);

    emit dataChanged(index, index);

    return true;
}

Qt::ItemFlags GoogleBooksSearchModel::flags(const QModelIndex &index) const
{
    if(index.isValid())
        return Qt::ItemIsEnabled|Qt::ItemIsEditable|Qt::ItemIsSelectable;

    return 0;
}

void GoogleBooksSearchModel::doSearch()
{
    if(this->isBusy())
        return;

    this->setBusy(true);

    static QNetworkAccessManager nam;

    QUrl url;
    url.setScheme("https");
    url.setHost("www.googleapis.com");
    url.setPath("/books/v1/volumes");

    QUrlQuery uq;
    uq.addQueryItem("q", m_searchString);
    uq.addQueryItem("startIndex", QString::number(m_searchResults.size()));
    url.setQuery(uq);

    QNetworkRequest req(url);
    QNetworkReply *reply = nam.get(req);
    QObject::connect(reply, &QNetworkReply::finished,
                     [=]() {
        const QJsonDocument jsonDoc
                = QJsonDocument::fromJson(reply->readAll());
        const QJsonObject jsonObj = jsonDoc.object();
        reply->deleteLater();

        const QJsonArray newResults = jsonObj.value("items").toArray();

        this->beginInsertRows(QModelIndex(),
                              m_searchResults.size(),
                              m_searchResults.size() + newResults.size()-1);
        m_maxSearchResultsAvailable = jsonObj.value("totalItems").toInt();
        for(int i=0; i<newResults.size(); i++)
            m_searchResults.append( newResults.at(i) );
        this->endInsertRows();

        this->setBusy(false);
    });
    QObject::connect(reply, &QNetworkReply::sslErrors,
            [=](const QList<QSslError> &errors) {
        reply->ignoreSslErrors(errors);
    });
}

void GoogleBooksSearchModel::setBusy(bool val)
{
    if(m_busy == val)
        return;

    m_busy = val;
    emit busyChanged();
}



