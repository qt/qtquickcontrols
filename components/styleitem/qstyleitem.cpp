/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the examples of the Qt Toolkit.
**
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOTgall
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qstyleitem.h"

#include <QtGui/QPainter>
#include <QtGui/QStyle>
#include <QtGui/QStyleOption>
#include <QtGui/QApplication>
#include <QtGui/QMainWindow>
#include <QtGui/QGroupBox>
#include <QtGui/QToolBar>
#include <QtGui/QMenu>
#include <QtCore/QStringBuilder>


QStyleItem::QStyleItem(QDeclarativeItem *parent)
    : QDeclarativeItem(parent),
    m_dummywidget(0),
    m_styleoption(0),
    m_sunken(false),
    m_raised(false),
    m_active(true),
    m_selected(false),
    m_focus(false),
    m_on(false),
    m_horizontal(true),
    m_sharedWidget(false),
    m_minimum(0),
    m_maximum(100),
    m_value(0),
    m_paintMargins(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    setCacheMode(QGraphicsItem::DeviceCoordinateCache);
    setSmooth(true);

    connect(this, SIGNAL(infoChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(onChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(selectedChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(textChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(raisedChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(sunkenChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(hoverChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(maximumChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(minimumChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(valueChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(horizontalChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(focusChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(elementTypeChanged()), this, SLOT(updateItem()));
}

QStyleItem::~QStyleItem()
{
    delete m_styleoption;
    m_styleoption = 0;

    if (!m_sharedWidget) {
        delete m_dummywidget;
        m_dummywidget = 0;
    }
}

void QStyleItem::initStyleOption()
{
    QString type = elementType();
    if (m_styleoption)
        m_styleoption->state = 0;

    if (type == QLatin1String("button")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionButton();

        QStyleOptionButton *opt = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        opt->text = text();
        opt->features = (activeControl() == "default") ?
                        QStyleOptionButton::DefaultButton :
                        QStyleOptionButton::None;
    }
    else if (type == QLatin1String("itemrow")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionViewItemV4();

        QStyleOptionViewItemV4 *opt = qstyleoption_cast<QStyleOptionViewItemV4*>(m_styleoption);
        opt->features = 0;
        if (activeControl() == "alternate")
            opt->features |= QStyleOptionViewItemV2::Alternate;
    }
    else if (type == QLatin1String("item")) {
        if (!m_styleoption) {
            m_styleoption = new QStyleOptionViewItemV4();
        }
        QStyleOptionViewItemV4 *opt = qstyleoption_cast<QStyleOptionViewItemV4*>(m_styleoption);
        opt->features = QStyleOptionViewItemV4::HasDisplay;
        opt->text = text();
        opt->textElideMode = Qt::ElideRight;
        QPalette pal = m_styleoption->palette;
        pal.setBrush(QPalette::Base, Qt::NoBrush);
        m_styleoption->palette = pal;
    }
    else if (type == QLatin1String("header")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionHeader();

        QStyleOptionHeader *opt = qstyleoption_cast<QStyleOptionHeader*>(m_styleoption);
        opt->text = text();
        opt->sortIndicator = activeControl() == "down" ?
                    QStyleOptionHeader::SortDown
                  : activeControl() == "up" ?
                        QStyleOptionHeader::SortUp : QStyleOptionHeader::None;
        if (activeControl() == QLatin1String("beginning"))
            opt->position = QStyleOptionHeader::Beginning;
        else if (activeControl() == QLatin1String("end"))
            opt->position = QStyleOptionHeader::End;
        else if (activeControl() == QLatin1String("only"))
            opt->position = QStyleOptionHeader::OnlyOneSection;
        else
            opt->position = QStyleOptionHeader::Middle;

    }
    else if (type == QLatin1String("toolbutton")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionToolButton();

        QStyleOptionToolButton *opt =
                qstyleoption_cast<QStyleOptionToolButton*>(m_styleoption);
        opt->subControls = QStyle::SC_ToolButton;
        opt->state |= QStyle::State_AutoRaise;
        opt->activeSubControls = QStyle::SC_ToolButton;
    }
    else if (type == QLatin1String("toolbar")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionToolBar();
    }
    else if (type == QLatin1String("tab")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionTabV3();

        QStyleOptionTabV3 *opt =
                qstyleoption_cast<QStyleOptionTabV3*>(m_styleoption);
        opt->text = text();
        opt->shape = info() == "South" ? QTabBar::RoundedSouth : QTabBar::RoundedNorth;
        if (activeControl() == QLatin1String("beginning"))
            opt->position = QStyleOptionTabV3::Beginning;
        else if (activeControl() == QLatin1String("end"))
            opt->position = QStyleOptionTabV3::End;
        else if (activeControl() == QLatin1String("only"))
            opt->position = QStyleOptionTabV3::OnlyOneTab;
        else
            opt->position = QStyleOptionTabV3::Middle;

    } else if (type == QLatin1String("menu")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();
    }
    else if (type == QLatin1String("frame")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFrameV3();

        QStyleOptionFrameV3 *opt = qstyleoption_cast<QStyleOptionFrameV3*>(m_styleoption);
        opt->frameShape = QFrame::StyledPanel;
        opt->lineWidth = 1;
        opt->midLineWidth = 1;
    }
    else if (type == QLatin1String("tabframe")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionTabWidgetFrameV2();
        QStyleOptionTabWidgetFrameV2 *opt = qstyleoption_cast<QStyleOptionTabWidgetFrameV2*>(m_styleoption);
        opt->shape = (info() == "South") ? QTabBar::RoundedSouth : QTabBar::RoundedNorth;
        if (minimum())
            opt->selectedTabRect = QRect(value(), 0, minimum(), height());
        opt->tabBarSize = QSize(minimum() , height());
        // oxygen style needs this hack
        opt->leftCornerWidgetSize = QSize(value(), 0);
    }
    else if (type == QLatin1String("menuitem") || type == QLatin1String("comboboxitem")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();

        QStyleOptionMenuItem *opt = qstyleoption_cast<QStyleOptionMenuItem*>(m_styleoption);
        opt->checked = false;
        opt->text = text();
        opt->palette = widget()->palette();
    }
    else if (type == QLatin1String("checkbox") || type == QLatin1String("radiobutton")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionButton();

        QStyleOptionButton *opt = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        if (!on())
            opt->state |= QStyle::State_Off;
        opt->text = text();
    }
    else if (type == QLatin1String("edit")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFrameV3();

        QStyleOptionFrameV3 *opt = qstyleoption_cast<QStyleOptionFrameV3*>(m_styleoption);
        opt->lineWidth = 1; // this must be non-zero
    }
    else if (type == QLatin1String("combobox")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionComboBox();
        QStyleOptionComboBox *opt = qstyleoption_cast<QStyleOptionComboBox*>(m_styleoption);
        opt->currentText = text();
    }
    else if (type == QLatin1String("spinbox")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSpinBox();

        QStyleOptionSpinBox *opt = qstyleoption_cast<QStyleOptionSpinBox*>(m_styleoption);
        opt->frame = true;
        if (value() & 0x1)
            opt->activeSubControls = QStyle::SC_SpinBoxUp;
        else if (value() & (1<<1))
            opt->activeSubControls = QStyle::SC_SpinBoxDown;
        opt->subControls = QStyle::SC_All;
        if (value() & (1<<2))
            opt->stepEnabled |= QAbstractSpinBox::StepUpEnabled;
        if (value() & (1<<3))
            opt->stepEnabled |= QAbstractSpinBox::StepDownEnabled;
    }
    else if (type == QLatin1String("slider") || type == QLatin1String("dial")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSlider();

        QStyleOptionSlider *opt = qstyleoption_cast<QStyleOptionSlider*>(m_styleoption);
        opt->minimum = minimum();
        opt->maximum = maximum();
        // ### fixme - workaround for KDE inverted dial
        opt->sliderPosition = value();
        opt->tickInterval = 1200 / (opt->maximum - opt->minimum);
        if (style().startsWith(QLatin1String("oxygen")) && type == QLatin1String("dial"))
            opt->sliderValue  = maximum() - value();
        else
            opt->sliderValue = value();
        opt->subControls = QStyle::SC_SliderGroove | QStyle::SC_SliderHandle;
        opt->tickPosition = (activeControl() == "below") ?
                             QSlider::TicksBelow : (activeControl() == "above" ?
                                                    QSlider::TicksAbove:
                                                    QSlider::NoTicks);
        if (opt->tickPosition != QSlider::NoTicks)
            opt->subControls |= QStyle::SC_SliderTickmarks;

        opt->activeSubControls = QStyle::SC_None;
    }
    else if (type == QLatin1String("progressbar")) {
        if (QProgressBar *bar= qobject_cast<QProgressBar*>(widget())){
            bar->setMaximum(maximum());
            bar->setMinimum(minimum());
            if (maximum() != minimum())
                bar->setValue(1);
        }
        if (!m_styleoption)
            m_styleoption = new QStyleOptionProgressBarV2();

        QStyleOptionProgressBarV2 *opt = qstyleoption_cast<QStyleOptionProgressBarV2*>(m_styleoption);
        opt->orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->progress = value();
    }
    else if (type == QLatin1String("groupbox")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionGroupBox();

        QStyleOptionGroupBox *opt = qstyleoption_cast<QStyleOptionGroupBox*>(m_styleoption);
        opt->text = text();
        opt->lineWidth = 1;
        opt->subControls = QStyle::SC_GroupBoxLabel | QStyle::SC_GroupBoxFrame;
        if (activeControl() == "checkbox")
            opt->subControls |= QStyle::SC_GroupBoxCheckBox;

        if (QGroupBox *group= qobject_cast<QGroupBox*>(widget())) {
            group->setTitle(text());
            group->setCheckable(opt->subControls & QStyle::SC_GroupBoxCheckBox);
        }
    }
    else if (type == QLatin1String("scrollbar")) {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSlider();

        QStyleOptionSlider *opt = qstyleoption_cast<QStyleOptionSlider*>(m_styleoption);
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->pageStep = horizontal() ? width() : height();
        opt->orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt->sliderPosition = value();
        opt->sliderValue = value();
        opt->activeSubControls = (activeControl() == QLatin1String("up"))
                                 ? QStyle::SC_ScrollBarSubLine :
                                 (activeControl() == QLatin1String("down")) ?
                                 QStyle::SC_ScrollBarAddLine:
                                 QStyle::SC_ScrollBarSlider;

        opt->sliderValue = value();
        opt->subControls = QStyle::SC_All;

        QScrollBar *bar = qobject_cast<QScrollBar *>(widget());
        bar->setMaximum(maximum());
        bar->setMinimum(minimum());
        bar->setValue(value());
    }

    if (!m_styleoption)
        m_styleoption = new QStyleOption();

    m_styleoption->rect = QRect(m_paintMargins, m_paintMargins, width() - 2* m_paintMargins, height() - 2 * m_paintMargins);

    if (isEnabled())
        m_styleoption->state |= QStyle::State_Enabled;
    if (m_active)
        m_styleoption->state |= QStyle::State_Active;
    if (m_sunken)
        m_styleoption->state |= QStyle::State_Sunken;
    if (m_raised)
        m_styleoption->state |= QStyle::State_Raised;
    if (m_selected)
        m_styleoption->state |= QStyle::State_Selected;
    if (m_focus)
        m_styleoption->state |= QStyle::State_HasFocus;
    if (m_on)
        m_styleoption->state |= QStyle::State_On;
    if (m_hover)
        m_styleoption->state |= QStyle::State_MouseOver;
    if (m_horizontal)
        m_styleoption->state |= QStyle::State_Horizontal;

    if (widget()) {
        if (type == QLatin1String("tab") && style() != QLatin1String("mac")) {
            // Some styles actually check the beginning and end position
            // using widget geometry, so we have to trick it
            widget()->setGeometry(0, 0, width(), height());
            if (activeControl() != "beginning")
                m_styleoption->rect.translate(1, 0); // Don't position at start of widget
            if (activeControl() != "end")
                widget()->resize(200, height());
        }
#ifdef Q_WS_WIN
        else widget()->resize(width(), height());
#endif

        widget()->setEnabled(isEnabled());
        m_styleoption->fontMetrics = widget()->fontMetrics();
        if (!m_styleoption->palette.resolve())
            m_styleoption->palette = widget()->palette();
        if (m_hint.contains("mac.mini")) {
            widget()->setAttribute(Qt::WA_MacMiniSize);
        } else if (m_hint.contains("mac.small")) {
            widget()->setAttribute(Qt::WA_MacSmallSize);
        }
    }
}

/*
 *   Property style
 *
 *   Returns a simplified style name.
 *
 *   QMacStyle = "mac"
 *   QWindowsXPStyle = "windowsxp"
 *   QPlastiqueStyle = "plastique"
 */

QString QStyleItem::style() const
{
    QString style = qApp->style()->metaObject()->className();
    if (style.startsWith(QLatin1Char('Q')))
        style = style.right(style.length() - 1);
    if (style.endsWith("Style"))
        style = style.left(style.length() - 5);
    return style.toLower();
}

QString QStyleItem::hitTest(int px, int py)
{
    QString type = elementType();
    QStyle::SubControl subcontrol = QStyle::SC_All;
    initStyleOption();
    if (type == QLatin1String("spinbox")) {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_SpinBox,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_SpinBoxUp)
            return "up";
        else if (subcontrol == QStyle::SC_SpinBoxDown)
            return "down";

    } else if (type == QLatin1String("slider")) {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_Slider,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_SliderHandle)
            return "handle";

    } else if (type == QLatin1String("scrollbar")) {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_ScrollBar,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_ScrollBarSlider)
            return "handle";

        if (subcontrol == QStyle::SC_ScrollBarSubLine
            || subcontrol == QStyle::SC_ScrollBarSubPage)
            return "up";

        if (subcontrol == QStyle::SC_ScrollBarAddLine
            || subcontrol == QStyle::SC_ScrollBarAddPage)
            return "down";
    }
    return "none";
}

QSize QStyleItem::sizeFromContents(int width, int height)
{
    QString metric = m_type;
    initStyleOption();

    QSize size;
    if (metric == QLatin1String("checkbox")) {
        size =  qApp->style()->sizeFromContents(QStyle::CT_CheckBox, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("toolbutton")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_ToolButton, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("button")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_PushButton, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("tab")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_TabBarTab, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("combobox")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_ComboBox, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("spinbox")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_SpinBox, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("slider")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_Slider, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("progressbar")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_ProgressBar, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("edit")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_LineEdit, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("groupbox")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_GroupBox, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("header")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_HeaderSection, m_styleoption, QSize(width,height), widget());
    } else if (metric == QLatin1String("itemrow") || metric == QLatin1String("item")) {
        size = qApp->style()->sizeFromContents(QStyle::CT_ItemViewItem, m_styleoption, QSize(width,height), widget());
    }

#ifdef Q_WS_MAC
    // ### hack - With even heights, the text baseline is off on mac
    if (size.height() %2 == 0)
        size.setHeight(size.height() + 1);
#endif
    return size;
}


int QStyleItem::pixelMetric(const QString &metric)
{

    if (metric == "scrollbarExtent")
        return qApp->style()->pixelMetric(QStyle::PM_ScrollBarExtent, 0, widget());
    else if (metric == "defaultframewidth")
        return qApp->style()->pixelMetric(QStyle::PM_DefaultFrameWidth, 0, widget());
    else if (metric == "taboverlap")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabOverlap, 0 , widget());
    else if (metric == "tabbaseoverlap")
#ifdef Q_WS_WIN
        // On windows the tabbar paintmargin extends the overlap by one pixels
        return 1 + qApp->style()->pixelMetric(QStyle::PM_TabBarBaseOverlap, 0 , widget());
#else
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseOverlap, 0 , widget());
#endif
    else if (metric == "tabhspace")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabHSpace, 0 , widget());
    else if (metric == "tabvspace")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabVSpace, 0 , widget());
    else if (metric == "tabbaseheight")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseHeight, 0 , widget());
    else if (metric == "tabvshift")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabShiftVertical, 0 , widget());
    else if (metric == "menuhmargin")
        return qApp->style()->pixelMetric(QStyle::PM_MenuHMargin, 0 , widget());
    else if (metric == "menuvmargin")
        return qApp->style()->pixelMetric(QStyle::PM_MenuVMargin, 0 , widget());
    else if (metric == "menupanelwidth")
        return qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth, 0 , widget());
    else if (metric == "scrollbarspacing")
        return qApp->style()->pixelMetric(QStyle::PM_ScrollView_ScrollBarSpacing, 0 , widget());
    return 0;
}

QVariant QStyleItem::styleHint(const QString &metric)
{
    initStyleOption();
    if (metric == "comboboxpopup") {
        return qApp->style()->styleHint(QStyle::SH_ComboBox_Popup, m_styleoption);
    } else if (metric == "highlightedTextColor") {
        if (widget())
            return widget()->palette().highlightedText().color().name();
        return qApp->palette().highlightedText().color().name();
    } else if (metric == "textColor") {
        if (widget())
            return widget()->palette().text().color().name();
        return qApp->palette().text().color().name();
    } else if (metric == "focuswidget") {
        return qApp->style()->styleHint(QStyle::SH_FocusFrame_AboveWidget);

    } else if (metric == "tabbaralignment") {
        int result = qApp->style()->styleHint(QStyle::SH_TabBar_Alignment);
        if (result == Qt::AlignCenter)
            return "center";
        return "left";

    } else if (metric == "framearoundcontents")
        return qApp->style()->styleHint(QStyle::SH_ScrollView_FrameOnlyAroundContents);
    return 0;
}

void QStyleItem::setCursor(const QString &str)
{
    if (m_cursor != str) {
        m_cursor = str;
        if (m_cursor == "sizehorcursor")
            QDeclarativeItem::setCursor(Qt::SizeHorCursor);
        else if (m_cursor == "sizevercursor")
            QDeclarativeItem::setCursor(Qt::SizeVerCursor);
        else if (m_cursor == "sizeallcursor")
            QDeclarativeItem::setCursor(Qt::SizeAllCursor);
        else if (m_cursor == "splithcursor")
            QDeclarativeItem::setCursor(Qt::SplitHCursor);
        else if (m_cursor == "splitvcursor")
            QDeclarativeItem::setCursor(Qt::SplitVCursor);
        else if (m_cursor == "wait")
            QDeclarativeItem::setCursor(Qt::WaitCursor);
        emit cursorChanged();
    }
}

void QStyleItem::setElementType(const QString &str)
{
    if (m_type == str)
        return;

    m_type = str;
    emit elementTypeChanged();

    if (m_dummywidget && !m_sharedWidget) {
        delete m_dummywidget;
        m_dummywidget = 0;
    }

    if (m_styleoption) {
        delete m_styleoption;
        m_styleoption = 0;
    }

    // Only enable visible if the widget can animate
    bool visible = false;
    if (str == "menu" || str == "menuitem") {
        // Since these are used by the delegate, it makes no
        // sense to re-create them per item
        static QWidget *menu = new QMenu();
        m_sharedWidget = true;
        m_dummywidget = menu;
    } else if (str == "item" || str == "itemrow" || str == "header") {
        // Since these are used by the delegate, it makes no
        // sense to re-create them per item
        static QTreeView *menu = new QTreeView();
        m_sharedWidget = true;
        if (str == "header")
            m_dummywidget = menu->header();
        else
            m_dummywidget = menu;
    } else if (str == "groupbox") {
        // Since these are used by the delegate, it makes no
        // sense to re-create them per item
        static QGroupBox *group = new QGroupBox();
        m_sharedWidget = true;
        m_dummywidget = group;
    } if (str == "tabframe" || str == "tab") {
        static QTabWidget *tabframe = new QTabWidget();
        m_sharedWidget = true;
        if (str == "tab")
            m_dummywidget = tabframe->findChild<QTabBar*>();
        else
            m_dummywidget = tabframe;

    } else if (str == "comboboxitem")  {
    // Gtk uses qobject cast, hence we need to separate this from menuitem
    // On mac, we temporarily use the menu item because it has more accurate
    // palette.
#ifdef Q_WS_MAC
        static QMenu *combo = new QMenu();
#else
        static QComboBox *combo = new QComboBox();
#endif
        m_sharedWidget = true;
        m_dummywidget = combo;
    } else if (str == "toolbar") {
        static QToolBar *tb = 0;
        if (!tb) {
            QMainWindow *mw = new QMainWindow();
            tb = new QToolBar(mw);
        }
        m_dummywidget = tb;

    } else if (str == "toolbutton") {
        static QToolButton *tb = 0;
        static QToolBar *bar = 0;
        // KDE animations are too broken with these widgets
        if (!str.startsWith("oxygen")) {
            if (!tb) {
                bar = new QToolBar(0);
                tb = new QToolButton(bar);
            }
        }
        m_sharedWidget = true;
        m_dummywidget = tb;
    } else if (str == "slider") {
        static QSlider *slider = new QSlider();
        m_sharedWidget = true;
        m_dummywidget = slider;
    } else if (str == "frame") {
        static QFrame *frame = new QFrame();
        m_sharedWidget = true;
        m_dummywidget = frame;
    } else if (str == "combobox") {
        m_dummywidget = new QComboBox();
        visible = true;
    } else if (str == "progressbar") {
        m_dummywidget = new QProgressBar();
        visible = true;
    } else if (str == "button") {
        m_dummywidget = new QPushButton();
        visible = true;
    } else if (str == "checkbox") {
        m_dummywidget = new QCheckBox();
        visible = true;
    } else if (str == "radiobutton") {
        m_dummywidget = new QRadioButton();
        visible = true;
    } else if (str == "edit") {
        m_dummywidget = new QLineEdit();
        visible = true;
    } else if (str == "spinbox") {
#ifndef Q_WS_WIN // Vista spinbox is currently not working due to grabwidget
        m_dummywidget = new QSpinBox();
        visible = true;
#endif
    } else if (str == "scrollbar") {
        m_dummywidget = new QScrollBar();
        visible = true;
    }
    if (m_dummywidget) {
        m_dummywidget->installEventFilter(this);
        m_dummywidget->setAttribute(Qt::WA_QuitOnClose, false); // dont keep app open
        m_dummywidget->winId();
#ifdef Q_WS_MAC
        m_dummywidget->setVisible(visible); // Mac require us to set the visibility before this
#endif
        m_dummywidget->setAttribute(Qt::WA_DontShowOnScreen);
        m_dummywidget->setAttribute(Qt::WA_LayoutUsesWidgetRect);
        m_dummywidget->setVisible(visible);
    }
}

bool QStyleItem::eventFilter(QObject *o, QEvent *e) {
    if (e->type() == QEvent::Paint) {
        updateItem();
        return true;
    }
    return QObject::eventFilter(o, e);
}

void QStyleItem::showToolTip(const QString &str)
{
    QPointF scene = mapToScene(width() - 20, 0);
    QPoint global = qApp->focusWidget()->mapToGlobal(scene.toPoint());
    QToolTip::showText(QPoint(global.x(), global.y()), str);
}

QRect QStyleItem::subControlRect(const QString &subcontrolString)
{
    QStyle::SubControl subcontrol = QStyle::SC_None;
    QString m_type = elementType();
    initStyleOption();
    if (m_type == QLatin1String("spinbox")) {
        QStyle::ComplexControl control = QStyle::CC_SpinBox;
        if (subcontrolString == QLatin1String("down"))
            subcontrol = QStyle::SC_SpinBoxDown;
        else if (subcontrolString == QLatin1String("up"))
            subcontrol = QStyle::SC_SpinBoxUp;
        else if (subcontrolString == QLatin1String("edit")){
            subcontrol = QStyle::SC_SpinBoxEditField;
        }
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol, widget());

    } else if (m_type == QLatin1String("slider")) {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_SliderHandle;
        else if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_SliderGroove;
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol, widget());

    } else if (m_type == QLatin1String("scrollbar")) {
        QStyle::ComplexControl control = QStyle::CC_ScrollBar;
        if (subcontrolString == QLatin1String("slider"))
            subcontrol = QStyle::SC_ScrollBarSlider;
        if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_ScrollBarGroove;
        else if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_ScrollBarSlider;
        else if (subcontrolString == QLatin1String("add"))
            subcontrol = QStyle::SC_ScrollBarAddPage;
        else if (subcontrolString == QLatin1String("sub"))
            subcontrol = QStyle::SC_ScrollBarSubPage;
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol, widget());
    }
    return QRect();
}

void QStyleItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    if (width() < 1 || height() <1)
        return;

    QString type = elementType();
    initStyleOption();

    if (widget()) {
        painter->save();
        painter->setFont(widget()->font());
        painter->translate(-m_styleoption->rect.left() + m_paintMargins, 0);
    }

    if (type == QLatin1String("button")) {
        qApp->style()->drawControl(QStyle::CE_PushButton, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("itemrow")) {
        QPixmap pixmap;
        // Only draw through style once
        const QString pmKey = QLatin1Literal("itemrow") % QString::number(m_styleoption->state,16) % activeControl();
        if (!QPixmapCache::find(pmKey, pixmap) || pixmap.width() < width()) {
            int newSize = width();
            pixmap = QPixmap(newSize, height());
            pixmap.fill(Qt::transparent);
            QPainter pixpainter(&pixmap);
            qApp->style()->drawPrimitive(QStyle::PE_PanelItemViewRow, m_styleoption, &pixpainter, widget());
            if (!qApp->style()->styleHint(QStyle::SH_ItemView_ShowDecorationSelected) && selected())
                pixpainter.fillRect(m_styleoption->rect, m_styleoption->palette.highlight());
            QPixmapCache::insert(pmKey, pixmap);
        }
        painter->drawPixmap(0, 0, pixmap);
    } else if (type == QLatin1String("item")) {
        qApp->style()->drawControl(QStyle::CE_ItemViewItem, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("header")) {
        widget()->resize(m_styleoption->rect.size()); // macstyle explicitly uses the widget height
        qApp->style()->drawControl(QStyle::CE_Header, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("toolbutton")) {
        qApp->style()->drawComplexControl(QStyle::CC_ToolButton, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter, widget());
    }
    else if (type == QLatin1String("tab")) {
        qApp->style()->drawControl(QStyle::CE_TabBarTab, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("frame")) {
        qApp->style()->drawControl(QStyle::CE_ShapedFrame, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("focusframe")) {
        qApp->style()->drawControl(QStyle::CE_FocusFrame, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("tabframe")) {
        qApp->style()->drawPrimitive(QStyle::PE_FrameTabWidget, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("menuitem") || type == QLatin1String("comboboxitem")) {
        qApp->style()->drawControl(QStyle::CE_MenuItem, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("checkbox")) {
        qApp->style()->drawControl(QStyle::CE_CheckBox, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("radiobutton")) {
        qApp->style()->drawControl(QStyle::CE_RadioButton, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("edit")) {
        qApp->style()->drawPrimitive(QStyle::PE_PanelLineEdit, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("widget")) {
        qApp->style()->drawPrimitive(QStyle::PE_Widget, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("combobox")) {
        qApp->style()->drawComplexControl(QStyle::CC_ComboBox,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter, widget());
        qApp->style()->drawControl(QStyle::CE_ComboBoxLabel, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("spinbox")) {
        qApp->style()->drawComplexControl(QStyle::CC_SpinBox,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter, widget());
    }
    else if (type == QLatin1String("slider")) {
        qApp->style()->drawComplexControl(QStyle::CC_Slider,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter, widget());
    }
    else if (type == QLatin1String("dial")) {
        qApp->style()->drawComplexControl(QStyle::CC_Dial,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter, widget());
    }
    else if (type == QLatin1String("progressbar")) {
        qApp->style()->drawControl(QStyle::CE_ProgressBar, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("toolbar")) {
        qApp->style()->drawControl(QStyle::CE_ToolBar, m_styleoption, painter, widget());
    }
    else if (type == QLatin1String("groupbox")) {
        qApp->style()->drawComplexControl(QStyle::CC_GroupBox, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter, widget());
    }
    else if (type == QLatin1String("scrollbar")) {
        qApp->style()->drawComplexControl(QStyle::CC_ScrollBar, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter, widget());
    }
    else if (type == QLatin1String("menu")) {
        if (QMenu *menu = qobject_cast<QMenu*>(widget())) {
            m_styleoption->palette = menu->palette();
        }
        QStyleHintReturnMask val;
        qApp->style()->styleHint(QStyle::SH_Menu_Mask, m_styleoption, widget(), &val);
        painter->save();
        painter->setClipRegion(val.region);
        painter->fillRect(m_styleoption->rect, m_styleoption->palette.window());
        painter->restore();
        qApp->style()->drawPrimitive(QStyle::PE_PanelMenu, m_styleoption, painter, widget());

        QStyleOptionFrame frame;
        frame.lineWidth = qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth);
        frame.midLineWidth = 0;
        frame.rect = m_styleoption->rect;
        qApp->style()->drawPrimitive(QStyle::PE_FrameMenu, &frame, painter, widget());
    }
    if (widget())
        painter->restore();
}

int QStyleItem::textWidth(const QString &text)
{
    if (widget())
        return widget()->fontMetrics().boundingRect(text).width();
    return qApp->fontMetrics().boundingRect(text).width();
}

int QStyleItem::fontHeight()
{
    if (widget())
        return widget()->fontMetrics().height();
    return qApp->fontMetrics().height();
}

QString QStyleItem::fontFamily()
{
    if (widget())
        return widget()->font().family();
    return qApp->font().family();
}

double QStyleItem::fontPointSize()
{
    if (widget())
        return widget()->font().pointSizeF();
    return qApp->font().pointSizeF();
}
