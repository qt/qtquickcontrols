#include "qtsplitterbase.h"

QtSplitterBase::QtSplitterBase(QDeclarativeItem *parent)
    : QDeclarativeItem(parent)
{
}

QtSplitterAttached *QtSplitterBase::qmlAttachedProperties(QObject *object)
{
    return new QtSplitterAttached(object);
}

void QtSplitterAttached::setExpanding(bool expanding)
{
    m_expanding = expanding;
    emit expandingChanged(expanding);
}

void QtSplitterAttached::setMaximumSize(qreal width)
{
    m_maximumSize = width;
    emit maximumSizeChanged(width);
}


void QtSplitterAttached::setMinimumSize(qreal width)
{
    m_minimumSize = width;
    emit minimumSizeChanged(width);
}

QtSplitterAttached::QtSplitterAttached(QObject *object)
    : QObject(object),
      m_minimumSize(-1),
      m_maximumSize(-1),
      m_percentageSize(-1),
      m_itemIndex(-1),
      m_expanding(false)
{
}
