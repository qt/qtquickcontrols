#include "qtoplevelwindow.h"

QTopLevelWindow::QTopLevelWindow()
    : QMainWindow(), _view(new QDeclarativeView) {
    setVisible(false);
    setCentralWidget(_view);
}

QTopLevelWindow::~QTopLevelWindow()
{
    //we need this to break the parental loop of QWindowItem and QTopLevelWindow
    _view->scene()->setParent(0);
}

void QTopLevelWindow::registerChildWindow(QTopLevelWindow* child)
{
    qDebug() << child << "is a child of" << this;
    _childWindows.insert(child);
}

void QTopLevelWindow::hideChildWindows()
{
    foreach(QTopLevelWindow* child, _childWindows) {
        child->hide();
    }
}

bool QTopLevelWindow::event(QEvent *event) {
    switch (event->type()) {
        case QEvent::WindowStateChange:
            emit windowStateChanged();
            break;
        case QEvent::Show:
            emit visibilityChanged();
            break;
        case QEvent::Hide:
            hideChildWindows();
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
