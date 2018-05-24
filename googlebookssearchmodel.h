#ifndef GOOGLEBOOKSSEARCHMODEL_H
#define GOOGLEBOOKSSEARCHMODEL_H

#include <QJsonArray>
#include <QAbstractListModel>

class GoogleBooksSearchModel : public QAbstractListModel
{
    Q_OBJECT

public:
    GoogleBooksSearchModel(QObject *parent=0);
    ~GoogleBooksSearchModel();

    Q_PROPERTY(QString searchString READ searchString WRITE setSearchString NOTIFY searchStringChanged)
    void setSearchString(const QString &val);
    QString searchString() const;
    Q_SIGNAL void searchStringChanged();

    Q_PROPERTY(bool busy READ isBusy NOTIFY busyChanged)
    bool isBusy() const { return m_busy; }
    Q_SIGNAL void busyChanged();

    enum Roles
    {
        TitleRole = Qt::UserRole,
        AuthorsRole,
        DescriptionRole,
        ThumbnailRole,
        SearchResultRole
    };

    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    void fetchMore(const QModelIndex &parent);
    bool canFetchMore(const QModelIndex &parent) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Qt::ItemFlags flags(const QModelIndex &index) const;

private:
    void doSearch();
    void setBusy(bool val);

private:
    bool m_busy;
    QString m_searchString;
    int m_maxSearchResultsAvailable;
    QJsonArray m_searchResults;
};

#endif // GOOGLEBOOKSSEARCHMODEL_H
