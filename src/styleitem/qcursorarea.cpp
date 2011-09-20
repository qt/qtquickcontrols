#include "qcursorarea.h"

QCursorArea::QCursorArea(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
}

void QCursorArea::setCursor(Cursor str)
{
    if (m_cursor != str) {
        m_cursor = str;
        if (m_cursor == SizeHorCursor)
            QDeclarativeItem::setCursor(Qt::SizeHorCursor);
        else if (m_cursor == SizeVerCursor)
            QDeclarativeItem::setCursor(Qt::SizeVerCursor);
        else if (m_cursor == SizeAllCursor)
            QDeclarativeItem::setCursor(Qt::SizeAllCursor);
        else if (m_cursor == SplitHCursor)
            QDeclarativeItem::setCursor(Qt::SplitHCursor);
        else if (m_cursor == SplitVCursor)
            QDeclarativeItem::setCursor(Qt::SplitVCursor);
        else if (m_cursor == WaitCursor)
            QDeclarativeItem::setCursor(Qt::WaitCursor);
        else if (m_cursor == PointingHandCursor)
            QDeclarativeItem::setCursor(Qt::PointingHandCursor);
        emit cursorChanged();
    }
}
