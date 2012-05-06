#include "qtooltiparea.h"
#include <QtWidgets/QToolTip>
#include <QtWidgets/QApplication>
#include <QtWidgets/QGraphicsSceneEvent>

QTooltipArea::QTooltipArea(QQuickItem *parent) :
    QQuickItem(parent),
    m_containsMouse(false)
{
    setAcceptHoverEvents(true);
    connect(&m_tiptimer, SIGNAL(timeout()), this, SLOT(timeout()));
}

void QTooltipArea::setText(const QString &t)
{
    if (t != m_text) {
        m_text = t;
        emit textChanged();
    }
}

void QTooltipArea::showToolTip(const QString &str) const
{
    Q_UNUSED(str);
    //QToolTip::showText(cursor().pos(), str);
}

void QTooltipArea::hoverEnterEvent(QGraphicsSceneHoverEvent *event)

{
    Q_UNUSED(event);
    m_tiptimer.start(1000);

    m_containsMouse = true;
    emit containsMouseChanged();
    //QQuickItem::hoverEnterEvent(event);
}

void QTooltipArea::hoverLeaveEvent(QGraphicsSceneHoverEvent *event)
{
    Q_UNUSED(event);
    m_tiptimer.stop();
    m_containsMouse = false;
    emit containsMouseChanged();
    //QQuickItem::hoverLeaveEvent(event);
}

void QTooltipArea::timeout()
{
    showToolTip(m_text);
}
