#include "qtoplevelwindow.h"

#include <QDesktopWidget>

QTopLevelWindow::QTopLevelWindow()
    : QMainWindow(), _view(new QDeclarativeView), _positionIsDefined(false) {
    setVisible(false);
    setCentralWidget(_view);
    setAttribute(Qt::WA_DeleteOnClose);
}

QTopLevelWindow::~QTopLevelWindow()
{
    //we need this to break the parental loop of QWindowItem and QTopLevelWindow
    _view->scene()->setParent(0);
}

void QTopLevelWindow::registerChildWindow(QTopLevelWindow* child)
{
    _childWindows.insert(child);
    child->setParent(this);
}

void QTopLevelWindow::hideChildWindows()
{
    foreach(QTopLevelWindow* child, _childWindows) {
        child->hide();
    }
}

void QTopLevelWindow::initPosition()
{
    if (!_positionIsDefined)
        center();
    foreach(QTopLevelWindow* child, _childWindows) {
        child->initPosition();
    }
}

void QTopLevelWindow::center()
{
    QPoint parentCenter;
    if (parentWidget())
        parentCenter = parentWidget()->geometry().center();
    else
        parentCenter = QDesktopWidget().screenGeometry().center();
    QRect thisGeometry = geometry();
    thisGeometry.moveCenter(parentCenter);
    setGeometry(thisGeometry);
}

void QTopLevelWindow::move(int x, int y)
{
    move(QPoint(x,y));
}

void QTopLevelWindow::move(const QPoint &point)
{
    _positionIsDefined = true;
    QMainWindow::move(point);
}

void QTopLevelWindow::setWindowFlags(Qt::WindowFlags type)
{
    QWidget::setWindowFlags(type | Qt::Window);
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
        case QEvent::ParentChange:
            setAttribute(Qt::WA_DeleteOnClose, !parent());
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
