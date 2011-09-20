#ifndef CURSORAREA_H
#define CURSORAREA_H

#include <QDeclarativeItem>

class QCursorArea : public QDeclarativeItem
{
    Q_OBJECT
    Q_ENUMS(Cursor)
    Q_PROPERTY( Cursor cursor READ cursor WRITE setCursor NOTIFY cursorChanged)
public:
    enum Cursor {
        SizeHorCursor,
        SizeVerCursor,
        SizeAllCursor,
        SplitHCursor,
        SplitVCursor,
        WaitCursor,
        PointingHandCursor
    };

    explicit QCursorArea(QDeclarativeItem *parent = 0);

    void setCursor(Cursor str);
    Cursor cursor() const { return m_cursor; }

signals:
    void cursorChanged();

private:
    Cursor m_cursor;

};

#endif // CURSORAREA_H
