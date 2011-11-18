#include "qtooltiparea.h"
#include <QGraphicsView>
#include <QToolTip>
#include <QApplication>
#include <QGraphicsSceneEvent>

QTooltipArea::QTooltipArea(QDeclarativeItem *parent) :
    QDeclarativeItem(parent),
    m_containsMouse(false)
{
    setAcceptHoverEvents(true);
    connect(&m_tiptimer, SIGNAL(timeout()), this, SLOT(timeout()));
    m_tiptimer.setSingleShot(true);
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

    m_containsMouse = true;
    emit containsMouseChanged();
    QDeclarativeItem::hoverEnterEvent(event);
}

void QTooltipArea::hoverLeaveEvent(QGraphicsSceneHoverEvent *event)
{
    m_tiptimer.stop();
    m_containsMouse = false;
    emit containsMouseChanged();
    QDeclarativeItem::hoverLeaveEvent(event);
}

void QTooltipArea::timeout()
{
    showToolTip(m_text);
}
