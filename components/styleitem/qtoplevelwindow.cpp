#include "qtoplevelwindow.h"

QTopLevelWindow::QTopLevelWindow()
    : QMainWindow(), _view(new QDeclarativeView) {
    setVisible(false);
    setCentralWidget(_view);
}

QTopLevelWindow::~QTopLevelWindow()
{
    foreach(QTopLevelWindow* w, _childWindows) {
        delete w;
    }
    _childWindows.clear();
}

void QTopLevelWindow::registerChildWindow(QTopLevelWindow* child) {
    qDebug() << child << "is a child of" << this;
    _childWindows.insert(child);
}

bool QTopLevelWindow::event(QEvent *event) {
    switch (event->type()) {
        case QEvent::WindowStateChange:
            emit windowStateChanged();
            break;
        case QEvent::Show:
        case QEvent::Hide:
            emit visibilityChanged();
            break;
        case QEvent::Resize: {
            const QResizeEvent *resize = static_cast<const QResizeEvent *>(event);
            emit sizeChanged(resize->size());
            break;
        }
        default: break;
    }
    return QMainWindow::event(event);
}
