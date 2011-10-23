#include "qcursorarea.h"

QCursorArea::QCursorArea(QDeclarativeItem *parent)
    : QDeclarativeItem(parent),
      m_cursor(ArrowCursor)
{

}

void QCursorArea::setCursor(Cursor cursor)
{
    if (m_cursor == cursor)
        return;

    switch (cursor) {
    case ArrowCursor:
        QDeclarativeItem::setCursor(Qt::ArrowCursor);
        break;
    case SizeHorCursor:
        QDeclarativeItem::setCursor(Qt::SizeHorCursor);
        break;
    case SizeVerCursor:
        QDeclarativeItem::setCursor(Qt::SizeVerCursor);
        break;
    case SizeAllCursor:
        QDeclarativeItem::setCursor(Qt::SizeAllCursor);
        break;
    case SplitHCursor:
        QDeclarativeItem::setCursor(Qt::SplitHCursor);
        break;
    case SplitVCursor:
        QDeclarativeItem::setCursor(Qt::SplitVCursor);
        break;
    case WaitCursor:
        QDeclarativeItem::setCursor(Qt::WaitCursor);
        break;
    case PointingHandCursor:
        QDeclarativeItem::setCursor(Qt::PointingHandCursor);
        break;
    default:
        return;
    }

    m_cursor = cursor;
    emit cursorChanged();
}
