#include "qtooltiparea.h"
#include <QGraphicsView>
#include <QToolTip>
#include <QApplication>
#include <QGraphicsSceneEvent>

QTooltipArea::QTooltipArea(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
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
    QToolTip::showText(cursor().pos(), str);
}

void QTooltipArea::hoverEnterEvent(QGraphicsSceneHoverEvent *event)
{
    m_tiptimer.start(1000);
    return QDeclarativeItem::hoverEnterEvent(event);
}

void QTooltipArea::hoverLeaveEvent(QGraphicsSceneHoverEvent *event)
{
    m_tiptimer.stop();
    return QDeclarativeItem::hoverLeaveEvent(event);
}

void QTooltipArea::timeout()
{
    showToolTip(m_text);
}
