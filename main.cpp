#include <QApplication>
#include <QQuickView>
#include <QQmlEngine>
#include <QListView>
#include <QQmlContext>

#include "googlebookssearchmodel.h"

// https://developers.google.com/books/docs/v1/using#PerformingSearch

int main(int argc, char **argv)
{
    QApplication a(argc, argv);

    qmlRegisterType<GoogleBooksSearchModel>("com.stryker.models",
        1, 0, "GoogleBooksSearchModel");

    GoogleBooksSearchModel bookSearchModel;

    QQuickView qmlView;
    qmlView.engine()->rootContext()->setContextProperty("booksModel", &bookSearchModel);
    qmlView.setResizeMode(QQuickView::SizeRootObjectToView);
    qmlView.setSource(QUrl("qrc:/main.qml"));
    qmlView.show();

//    QListView listView;
//    listView.setModel(&bookSearchModel);
//    listView.show();

    return a.exec();
}







