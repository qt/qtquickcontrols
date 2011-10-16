#ifndef QTSPLITTERBASE_H
#define QTSPLITTERBASE_H

#import <QtDeclarative>


class QtSplitterAttached : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(qreal minimumHeight READ minimumHeight WRITE setMinimumHeight NOTIFY minimumHeightChanged)
    Q_PROPERTY(qreal maximumWidth READ maximumWidth WRITE setMaximumWidth NOTIFY maximumHeightChanged)
    Q_PROPERTY(qreal maximumHeight READ maximumHeight WRITE setMaximumHeight NOTIFY maximumHeight)
    Q_PROPERTY(qreal percentageSize READ percentageSize WRITE setPercentageSize NOTIFY percentageWidthSize)
    Q_PROPERTY(bool expanding READ expanding WRITE setExpanding NOTIFY expandingChanged)

public:
    explicit QtSplitterAttached(QObject *object);

    qreal minimumWidth() const { return m_minimumWidth; }
    void setMinimumWidth(qreal width);

    qreal minimumHeight() const { return m_minimumHeight; }
    void setMinimumHeight(qreal height);

    qreal maximumWidth() const { return m_maximumWidth; }
    void setMaximumWidth(qreal width);

    qreal maximumHeight() const { return m_maximumHeight; }
    void setMaximumHeight(qreal height);

    bool expanding() const { return m_expanding; }
    void setExpanding(bool expanding);

    qreal percentageSize() const { return m_percentageSize; }

public slots:
    void setPercentageSize(qreal arg) { m_percentageSize = arg; }

signals:
    void minimumWidthChanged(qreal arg);

    void expandingChanged(bool arg);

    void percentageWidthSize(qreal arg);

    void maximumHeight(qreal arg);

    void maximumHeightChanged(qreal arg);

    void minimumHeightChanged(qreal arg);

private:
    qreal m_minimumWidth;
    qreal m_minimumHeight;
    qreal m_maximumWidth;
    qreal m_maximumHeight;
    bool m_expanding;

    friend class QtSplitterBase;
    qreal m_percentageSize;
};


class QtSplitterBase : public QDeclarativeItem
{
    Q_OBJECT
public:
    explicit QtSplitterBase(QDeclarativeItem *parent = 0);
    ~QtSplitterBase() {}

    static QtSplitterAttached *qmlAttachedProperties(QObject *object);
};

QML_DECLARE_TYPEINFO(QtSplitterBase, QML_HAS_ATTACHED_PROPERTIES)

#endif // QTSPLITTERBASE_H
