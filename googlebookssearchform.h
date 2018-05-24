#ifndef GOOGLEBOOKSSEARCHFORM_H
#define GOOGLEBOOKSSEARCHFORM_H

#include <QWidget>

class QLabel;
class QLineEdit;
class QPushButton;
class QListView;
class GoogleBooksSearchModel;

class GoogleBooksSearchForm : public QWidget
{
    Q_OBJECT

public:
    explicit GoogleBooksSearchForm(QWidget *parent = 0);
    ~GoogleBooksSearchForm();

private:
    QLabel *m_label;
    QLineEdit *m_searchStringEdit;
    QPushButton *m_searchButton;
    QListView *m_searchResultsView;
    GoogleBooksSearchModel *m_searchModel;

};

#endif // GOOGLEBOOKSSEARCHFORM_H
