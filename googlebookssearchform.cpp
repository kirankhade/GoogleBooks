#include "googlebookssearchform.h"

#include <QBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QLineEdit>
#include <QListView>

#include "googlebookssearchmodel.h"

GoogleBooksSearchForm::GoogleBooksSearchForm(QWidget *parent) :
    QWidget(parent)
{
    QHBoxLayout *top = new QHBoxLayout;

    m_label = new QLabel("Search String");
    m_searchStringEdit = new QLineEdit;
    m_searchButton = new QPushButton("Search");
    top->addWidget(m_label);
    top->addWidget(m_searchStringEdit);
    top->addWidget(m_searchButton);

    m_searchResultsView = new QListView;
    m_searchModel = new GoogleBooksSearchModel(this);
    m_searchResultsView->setModel(m_searchModel);

    QVBoxLayout *layout = new QVBoxLayout;
    setLayout(layout);
    layout->addLayout(top);
    layout->addWidget(m_searchResultsView);

    connect(m_searchButton, &QPushButton::clicked, [=]() {
        m_searchModel->setSearchString(m_searchStringEdit->text());
    });

    connect(m_searchModel, &GoogleBooksSearchModel::busyChanged, [=]() {
        if(m_searchModel->isBusy())
            this->setEnabled(false);
        else
            this->setEnabled(true);
    });
}

GoogleBooksSearchForm::~GoogleBooksSearchForm()
{

}









