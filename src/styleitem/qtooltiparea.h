#ifndef QTOOLTIPAREA_H
#define QTOOLTIPAREA_H

#include <QDeclarativeItem>
#include <QTimer>

class QTooltipArea : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    QTooltipArea(QDeclarativeItem *parent = 0);
    void setText(const QString &t);
    QString text() const {return m_text;}
    void showToolTip(const QString &str) const;
    void hoverEnterEvent(QGraphicsSceneHoverEvent *event);
    void hoverLeaveEvent(QGraphicsSceneHoverEvent *event);

public slots:
    void timeout();

signals:
    void textChanged();

private:

    QTimer m_tiptimer;
    QString m_text;
};

#endif // QTOOLTIPAREA_H
