#include "qwindowwidget.h"
#include <QtCore/qdebug.h>
#include <QtGui/qevent.h>

QWindowWidget::QWindowWidget()
    :m_EmbeddedWindow(0)
{

}

void QWindowWidget::setEmbeddedWindow(QWindow *window)
{
    m_EmbeddedWindow = window;

    this->window()->winId(); // force parent (top-level) creation
    m_EmbeddedWindow->setParent(this->window()->windowHandle());
}

QWindow *QWindowWidget::embeddedWindow() const
{
    return m_EmbeddedWindow;
}

bool QWindowWidget::event(QEvent *event) {
    switch (event->type()) {
        case QEvent::Show:
            m_EmbeddedWindow->show();
            break;
        case QEvent::Hide:
            m_EmbeddedWindow->hide();
            break;
        case QEvent::Resize: {
            QResizeEvent *resize = static_cast<QResizeEvent *>(event);
            // qDebug() << "\n" << this << "resize current geom" << m_EmbeddedWindow->geometry() ;
            // qDebug() << "newsize" << resize->size();

            // Propagate resize, force pos to (0,0).
            m_EmbeddedWindow->setGeometry(QRect(QPoint(), resize->size()));
            break;
        }
        default: break;
    }
    return QWidget::event(event);
}

