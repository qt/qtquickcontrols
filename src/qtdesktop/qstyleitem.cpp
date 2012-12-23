/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qstyleitem.h"

#include <QtGui/QPainter>
#include <QtWidgets/QStyle>
#include <QtWidgets/QStyleOption>
#include <QtWidgets/QApplication>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QMenu>
#include <QtWidgets/QtWidgets>
#include <QtCore/QStringBuilder>

#ifdef Q_OS_MAC
#include <Carbon/Carbon.h>

static inline HIRect qt_hirectForQRect(const QRect &convertRect, const QRect &rect = QRect())
{
    return CGRectMake(convertRect.x() + rect.x(), convertRect.y() + rect.y(),
                      convertRect.width() - rect.width(), convertRect.height() - rect.height());
}

/*! \internal

    Returns the CoreGraphics CGContextRef of the paint device. 0 is
    returned if it can't be obtained. It is the caller's responsibility to
    CGContextRelease the context when finished using it.

    \warning This function is only available on Mac OS X.
    \warning This function is duplicated in qmacstyle_mac.mm
*/
CGContextRef qt_mac_cg_context(const QPaintDevice *pdev)
{

    if (pdev->devType() == QInternal::Image) {
         const QImage *i = static_cast<const  QImage*>(pdev);
         QImage *image = const_cast< QImage*>(i);
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        uint flags = kCGImageAlphaPremultipliedFirst;
        flags |= kCGBitmapByteOrder32Host;
        CGContextRef ret = 0;

        ret = CGBitmapContextCreate(image->bits(), image->width(), image->height(),
                                    8, image->bytesPerLine(), colorspace, flags);

        CGContextTranslateCTM(ret, 0, image->height());
        CGContextScaleCTM(ret, 1, -1);
        return ret;
    }
    return 0;
}

#endif

QStyleItem::QStyleItem(QQuickPaintedItem *parent)
    : QQuickPaintedItem(parent),
    m_styleoption(0),
    m_itemType(Undefined),
    m_sunken(false),
    m_raised(false),
    m_active(true),
    m_selected(false),
    m_focus(false),
    m_hover(false),
    m_on(false),
    m_horizontal(true),
    m_sharedWidget(false),
    m_minimum(0),
    m_maximum(100),
    m_value(0),
    m_step(0),
    m_paintMargins(0),
    m_contentWidth(0),
    m_contentHeight(0)

{
    if (!qApp->style()) {
        qWarning("\nError: No widget style available. \n\nQt Desktop Components "
               "currently depend on the widget module to function. \n"
               "Use QApplication when creating standalone executables.\n\n");
        exit(-1);
    }
    m_font = qApp->font();
    setFlag(QQuickItem::ItemHasContents, true);
    setSmooth(false);

    connect(this, SIGNAL(enabledChanged()), this, SLOT(updateItem()));
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
    connect(this, SIGNAL(hasFocusChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(elementTypeChanged()), this, SLOT(updateItem()));
    connect(this, SIGNAL(textChanged()), this, SLOT(updateSizeHint()));
    connect(this, SIGNAL(contentWidthChanged(int)), this, SLOT(updateSizeHint()));
    connect(this, SIGNAL(contentHeightChanged(int)), this, SLOT(updateSizeHint()));
}

QStyleItem::~QStyleItem()
{
    delete m_styleoption;
    m_styleoption = 0;
}

void QStyleItem::initStyleOption()
{
    QString type = elementType();
    if (m_styleoption)
        m_styleoption->state = 0;

    switch (m_itemType) {
    case Button: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionButton();

        QStyleOptionButton *opt = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        opt->text = text();
        opt->features = (activeControl() == "default") ?
                    QStyleOptionButton::DefaultButton :
                    QStyleOptionButton::None;
    }
        break;
    case ItemRow: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionViewItem();

        QStyleOptionViewItem *opt = qstyleoption_cast<QStyleOptionViewItem*>(m_styleoption);
        opt->features = 0;
        if (activeControl() == "alternate")
            opt->features |= QStyleOptionViewItem::Alternate;
    }
        break;

    case Splitter: {
        if (!m_styleoption) {
            m_styleoption = new QStyleOption;
        }
    }
        break;

    case Item: {
        if (!m_styleoption) {
            m_styleoption = new QStyleOptionViewItem();
        }
        QStyleOptionViewItem *opt = qstyleoption_cast<QStyleOptionViewItem*>(m_styleoption);
        opt->features = QStyleOptionViewItem::HasDisplay;
        opt->text = text();
        opt->textElideMode = Qt::ElideRight;
        QPalette pal = m_styleoption->palette;
        pal.setBrush(QPalette::Base, Qt::NoBrush);
        m_styleoption->palette = pal;
    }
        break;
    case Header: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionHeader();

        QStyleOptionHeader *opt = qstyleoption_cast<QStyleOptionHeader*>(m_styleoption);
        opt->text = text();
        opt->sortIndicator = activeControl() == "down" ?
                    QStyleOptionHeader::SortDown
                  : activeControl() == "up" ?
                        QStyleOptionHeader::SortUp : QStyleOptionHeader::None;
        if (info() == QLatin1String("beginning"))
            opt->position = QStyleOptionHeader::Beginning;
        else if (info() == QLatin1String("end"))
            opt->position = QStyleOptionHeader::End;
        else if (info() == QLatin1String("only"))
            opt->position = QStyleOptionHeader::OnlyOneSection;
        else
            opt->position = QStyleOptionHeader::Middle;
    }
        break;
    case ToolButton: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionToolButton();

        QStyleOptionToolButton *opt =
                qstyleoption_cast<QStyleOptionToolButton*>(m_styleoption);
        opt->subControls = QStyle::SC_ToolButton;
        opt->state |= QStyle::State_AutoRaise;
        opt->activeSubControls = QStyle::SC_ToolButton;
    }
        break;
    case ToolBar: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionToolBar();
    }
        break;
    case Tab: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionTab();

        QStyleOptionTab *opt = qstyleoption_cast<QStyleOptionTab*>(m_styleoption);
        opt->text = text();
        opt->shape = info() == "South" ? QTabBar::RoundedSouth : QTabBar::RoundedNorth;
        if (activeControl() == QLatin1String("beginning"))
            opt->position = QStyleOptionTab::Beginning;
        else if (activeControl() == QLatin1String("end"))
            opt->position = QStyleOptionTab::End;
        else if (activeControl() == QLatin1String("only"))
            opt->position = QStyleOptionTab::OnlyOneTab;
        else
            opt->position = QStyleOptionTab::Middle;

    } break;

    case Menu: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();
    }
        break;
    case Frame: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFrame();

        QStyleOptionFrame *opt = qstyleoption_cast<QStyleOptionFrame*>(m_styleoption);
        opt->frameShape = QFrame::StyledPanel;
        opt->lineWidth = 1;
        opt->midLineWidth = 1;
    }
        break;
    case TabFrame: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionTabWidgetFrame();
        QStyleOptionTabWidgetFrame *opt = qstyleoption_cast<QStyleOptionTabWidgetFrame*>(m_styleoption);
        opt->shape = (info() == "South") ? QTabBar::RoundedSouth : QTabBar::RoundedNorth;
        if (minimum())
            opt->selectedTabRect = QRect(value(), 0, minimum(), height());
        opt->tabBarSize = QSize(minimum() , height());
        // oxygen style needs this hack
        opt->leftCornerWidgetSize = QSize(value(), 0);
    }
        break;
    case MenuItem:
    case ComboBoxItem:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionMenuItem();

        QStyleOptionMenuItem *opt = qstyleoption_cast<QStyleOptionMenuItem*>(m_styleoption);
        opt->checked = false;
        opt->text = text();
    }
        break;
    case CheckBox:
    case RadioButton:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionButton();

        QStyleOptionButton *opt = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        if (!on())
            opt->state |= QStyle::State_Off;
        opt->text = text();
    }
        break;
    case Edit: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionFrame();

        QStyleOptionFrame *opt = qstyleoption_cast<QStyleOptionFrame*>(m_styleoption);
        opt->lineWidth = 1; // this must be non-zero
    }
        break;
    case ComboBox :{
        if (!m_styleoption)
            m_styleoption = new QStyleOptionComboBox();
        QStyleOptionComboBox *opt = qstyleoption_cast<QStyleOptionComboBox*>(m_styleoption);
        opt->currentText = text();
    }
        break;
    case SpinBox: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSpinBox();

        QStyleOptionSpinBox *opt = qstyleoption_cast<QStyleOptionSpinBox*>(m_styleoption);
        opt->frame = true;
        if (value() & 0x1)
            opt->activeSubControls = QStyle::SC_SpinBoxUp;
        else if (value() & (1<<1))
            opt->activeSubControls = QStyle::SC_SpinBoxDown;
        opt->subControls = QStyle::SC_All;
        opt->stepEnabled = 0;
        if (value() & (1<<2))
            opt->stepEnabled |= QAbstractSpinBox::StepUpEnabled;
        if (value() & (1<<3))
            opt->stepEnabled |= QAbstractSpinBox::StepDownEnabled;
    }
        break;
    case Slider:
    case Dial:
    {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSlider();

        QStyleOptionSlider *opt = qstyleoption_cast<QStyleOptionSlider*>(m_styleoption);
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->sliderPosition = value();
        opt->singleStep = step();

        if (opt->singleStep) {
            qreal numOfSteps = (opt->maximum - opt->minimum) / opt->singleStep;
            // at least 5 pixels between tick marks
            if (numOfSteps && (width() / numOfSteps < 5))
                opt->tickInterval = qRound((5*numOfSteps / width()) + 0.5)*step();
            else
                opt->tickInterval = opt->singleStep;
        } else // default Qt-components implementation
            opt->tickInterval = opt->maximum != opt->minimum ? 1200 / (opt->maximum - opt->minimum) : 0;

        opt->sliderValue = value();
        opt->subControls = QStyle::SC_SliderGroove | QStyle::SC_SliderHandle;
        opt->tickPosition = (activeControl() == "tick" ?
                    QSlider::TicksBelow : QSlider::NoTicks);
        if (opt->tickPosition != QSlider::NoTicks)
            opt->subControls |= QStyle::SC_SliderTickmarks;

        opt->activeSubControls = QStyle::SC_None;
    }
        break;
    case ProgressBar: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionProgressBar();

        QStyleOptionProgressBar *opt = qstyleoption_cast<QStyleOptionProgressBar*>(m_styleoption);
        opt->orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->progress = value();
    }
        break;
    case GroupBox: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionGroupBox();

        QStyleOptionGroupBox *opt = qstyleoption_cast<QStyleOptionGroupBox*>(m_styleoption);
        opt->text = text();
        opt->lineWidth = 1;
        opt->subControls = QStyle::SC_GroupBoxLabel;
        opt->features = 0;
        if (sunken()) { // Qt draws an ugly line here so I ignore it
            opt->subControls |= QStyle::SC_GroupBoxFrame;
        } else {
            opt->features |= QStyleOptionFrame::Flat;
        }
        if (activeControl() == "checkbox")
            opt->subControls |= QStyle::SC_GroupBoxCheckBox;

    }
        break;
    case ScrollBar: {
        if (!m_styleoption)
            m_styleoption = new QStyleOptionSlider();

        QStyleOptionSlider *opt = qstyleoption_cast<QStyleOptionSlider*>(m_styleoption);
        opt->minimum = minimum();
        opt->maximum = maximum();
        opt->pageStep = qMax(0, int(horizontal() ? width() : height()));
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

    }
    case MenuBar:
        if (!m_styleoption) {
            QStyleOptionMenuItem *menuOpt = new QStyleOptionMenuItem();
            menuOpt->menuItemType = QStyleOptionMenuItem::EmptyArea;
            m_styleoption = menuOpt;
        }

        break;
    case MenuBarItem:
        if (!m_styleoption) {
            QStyleOptionMenuItem *menuOpt = new QStyleOptionMenuItem();
           menuOpt->text = text();
           menuOpt->menuItemType = QStyleOptionMenuItem::Normal;
           m_styleoption = menuOpt;
        }
        break;
    default:
        break;
    }

    if (!m_styleoption)
        m_styleoption = new QStyleOption();

    m_styleoption->styleObject = this;
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

    if (m_hint.indexOf("mini") != -1) {
        m_styleoption->state |= QStyle::State_Mini;
    } else if (m_hint.indexOf("small") != -1) {
        m_styleoption->state |= QStyle::State_Small;
    }

}

/*
 *   Property style
 *
 *   Returns a simplified style name.
 *
 *   QMacStyle = "mac"
 *   QWindowsXPStyle = "windowsxp"
 *   QFusionStyle = "fusion"
 */

QString QStyleItem::style() const
{
    QString style = qApp->style()->metaObject()->className();
    style = style.toLower();
    if (style.startsWith(QLatin1Char('q')))
        style = style.right(style.length() - 1);
    if (style.endsWith("style"))
        style = style.left(style.length() - 5);
    return style.toLower();
}

QString QStyleItem::hitTest(int px, int py)
{
    QStyle::SubControl subcontrol = QStyle::SC_All;
    switch (m_itemType) {
    case SpinBox :{
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_SpinBox,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_SpinBoxUp)
            return "up";
        else if (subcontrol == QStyle::SC_SpinBoxDown)
            return "down";

    }
        break;

    case Slider: {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_Slider,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_SliderHandle)
            return "handle";

    }
        break;
    case ScrollBar: {
        subcontrol = qApp->style()->hitTestComplexControl(QStyle::CC_ScrollBar,
                                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                                          QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_ScrollBarSlider)
            return "handle";

        if (subcontrol == QStyle::SC_ScrollBarSubLine)
            return "up";
        else if (subcontrol == QStyle::SC_ScrollBarSubPage)
            return "upPage";

        if (subcontrol == QStyle::SC_ScrollBarAddLine)
            return "down";
        else if (subcontrol == QStyle::SC_ScrollBarAddPage)
            return "downPage";
    }
        break;
    default:
        break;
    }
    return "none";
}

QSize QStyleItem::sizeFromContents(int width, int height)
{
    initStyleOption();

    QSize size;
    switch (m_itemType) {
    case RadioButton:
        size =  qApp->style()->sizeFromContents(QStyle::CT_RadioButton, m_styleoption, QSize(width,height));
        break;
    case CheckBox:
        size =  qApp->style()->sizeFromContents(QStyle::CT_CheckBox, m_styleoption, QSize(width,height));
        break;
    case ToolBar:
        size = QSize(200, 40);
        break;
    case ToolButton: {
        QStyleOptionToolButton *btn = qstyleoption_cast<QStyleOptionToolButton*>(m_styleoption);
        int newWidth = qMax(width, btn->fontMetrics.width(btn->text));
        int newHeight = qMax(height, btn->fontMetrics.height());
        size = qApp->style()->sizeFromContents(QStyle::CT_ToolButton, m_styleoption, QSize(newWidth, newHeight)); }
        break;
    case Button: {
        QStyleOptionButton *btn = qstyleoption_cast<QStyleOptionButton*>(m_styleoption);
        int newWidth = qMax(width, btn->fontMetrics.width(btn->text));
        int newHeight = qMax(height, btn->fontMetrics.height());
        size = qApp->style()->sizeFromContents(QStyle::CT_PushButton, m_styleoption, QSize(newWidth, newHeight)); }
        break;
    case ComboBox: {
        QStyleOptionComboBox *btn = qstyleoption_cast<QStyleOptionComboBox*>(m_styleoption);
        int newWidth = qMax(width, btn->fontMetrics.width(btn->currentText));
        int newHeight = qMax(height, btn->fontMetrics.height());
        size = qApp->style()->sizeFromContents(QStyle::CT_ComboBox, m_styleoption, QSize(newWidth, newHeight)); }
        break;
    case SpinBox: {
        QStyleOptionSpinBox *box = qstyleoption_cast<QStyleOptionSpinBox*>(m_styleoption);
        int newWidth = qMax(width, box->fontMetrics.width(QLatin1String("0.0")));
        int newHeight = qMax(height, box->fontMetrics.height());
        size = qApp->style()->sizeFromContents(QStyle::CT_SpinBox, m_styleoption, QSize(newWidth, newHeight)); }
        break;
    case Tab:
        size = qApp->style()->sizeFromContents(QStyle::CT_TabBarTab, m_styleoption, QSize(width,height));
        break;
    case Slider:
        size = qApp->style()->sizeFromContents(QStyle::CT_Slider, m_styleoption, QSize(width,height));
        break;
    case ProgressBar:
        size = qApp->style()->sizeFromContents(QStyle::CT_ProgressBar, m_styleoption, QSize(width,height));
        break;
    case Edit:
        size = qApp->style()->sizeFromContents(QStyle::CT_LineEdit, m_styleoption, QSize(width,height));
        if (hint().indexOf("rounded") != -1)
            size += QSize(0, 3);
        break;
    case GroupBox:
        size = qApp->style()->sizeFromContents(QStyle::CT_GroupBox, m_styleoption, QSize(width,height));
        break;
    case Header:
        size = qApp->style()->sizeFromContents(QStyle::CT_HeaderSection, m_styleoption, QSize(width,height));
#ifdef Q_OS_MAC
        if (style() =="mac")
            size.setHeight(15);
#endif
        break;
    case ItemRow:
    case Item: //fall through
        size = qApp->style()->sizeFromContents(QStyle::CT_ItemViewItem, m_styleoption, QSize(width,height));
        break;
    case MenuBarItem: //fall through
        size = qApp->style()->sizeFromContents(QStyle::CT_MenuBarItem, m_styleoption, QSize(width,height));
        break;
    case MenuBar: //fall through
        size = qApp->style()->sizeFromContents(QStyle::CT_MenuBar, m_styleoption, QSize(width,height));
        break;
    default:
        break;
    }
    return size;
}

void QStyleItem::updateSizeHint()
{
    QSize implicitSize = sizeFromContents(m_contentWidth, m_contentHeight);
    setImplicitSize(implicitSize.width(), implicitSize.height());
}

int QStyleItem::pixelMetric(const QString &metric)
{

    if (metric == "scrollbarExtent")
        return qApp->style()->pixelMetric(QStyle::PM_ScrollBarExtent, 0) + 1;
    else if (metric == "defaultframewidth")
        return qApp->style()->pixelMetric(QStyle::PM_DefaultFrameWidth, 0);
    else if (metric == "taboverlap")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabOverlap, 0 );
    else if (metric == "tabbaseoverlap")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseOverlap, 0 );
    else if (metric == "tabhspace")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabHSpace, 0 );
    else if (metric == "indicatorwidth")
        return qApp->style()->pixelMetric(QStyle::PM_ExclusiveIndicatorWidth, 0 );
    else if (metric == "tabvspace")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabVSpace, 0 );
    else if (metric == "tabbaseheight")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseHeight, 0 );
    else if (metric == "tabvshift")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabShiftVertical, 0 );
    else if (metric == "menuhmargin")
        return qApp->style()->pixelMetric(QStyle::PM_MenuHMargin, 0 );
    else if (metric == "menuvmargin")
        return qApp->style()->pixelMetric(QStyle::PM_MenuVMargin, 0 );
    else if (metric == "menupanelwidth")
        return qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth, 0 );
    else if (metric == "splitterwidth")
        return qApp->style()->pixelMetric(QStyle::PM_SplitterWidth, 0 );
    else if (metric == "scrollbarspacing")
        return abs(qApp->style()->pixelMetric(QStyle::PM_ScrollView_ScrollBarSpacing, 0 ));
    return 0;
}

QVariant QStyleItem::styleHint(const QString &metric)
{
    initStyleOption();
    if (metric == "comboboxpopup") {
        return qApp->style()->styleHint(QStyle::SH_ComboBox_Popup, m_styleoption);
    } else if (metric == "highlightedTextColor") {
        return qApp->palette().highlightedText().color().name();
    } else if (metric == "textColor") {
        return qApp->palette().text().color().name();
    } else if (metric == "focuswidget") {
        return qApp->style()->styleHint(QStyle::SH_FocusFrame_AboveWidget);
    } else if (metric == "tabbaralignment") {
        int result = qApp->style()->styleHint(QStyle::SH_TabBar_Alignment);
        if (result == Qt::AlignCenter)
            return "center";
        return "left";
    } else if (metric == "framearoundcontents") {
        return qApp->style()->styleHint(QStyle::SH_ScrollView_FrameOnlyAroundContents);
    } else if (metric == "scrollToClickPosition")
        return qApp->style()->styleHint(QStyle::SH_ScrollBar_LeftClickAbsolutePosition);
    return 0;
}

void QStyleItem::setHint(const QStringList &str)
{
    if (m_hint != str) {
        m_hint = str;
        initStyleOption();
        updateSizeHint();
        if (m_styleoption->state & QStyle::State_Mini) {
            m_font.setPointSize(9.);
            emit fontChanged();
        } else if (m_styleoption->state & QStyle::State_Small) {
            m_font.setPointSize(11.);
            emit fontChanged();
        }
    }
}


void QStyleItem::setElementType(const QString &str)
{
    if (m_type == str)
        return;

    m_type = str;

    emit elementTypeChanged();
    if (m_styleoption) {
        delete m_styleoption;
        m_styleoption = 0;
    }

    // Only enable visible if the widget can animate
    if (str == "menu" || str == "menuitem") {
        m_itemType = (str == "menu") ? Menu : MenuItem;
    } else if (str == "item" || str == "itemrow" || str == "header") {
#ifdef Q_OS_MAC
        m_font.setPointSize(11.0);
        emit fontChanged();
#endif
        if (str == "header") {
            m_itemType = Header;
        } else {
            m_itemType = (str == "item") ? Item : ItemRow;
        }
    } else if (str == "groupbox") {
        m_itemType = GroupBox;
    } else if (str == "tab") {
        m_itemType = Tab;
    } else if (str == "tabframe") {
        m_itemType = TabFrame;
    } else if (str == "comboboxitem")  {
        // Gtk uses qobject cast, hence we need to separate this from menuitem
        // On mac, we temporarily use the menu item because it has more accurate
        // palette.
        m_itemType = ComboBoxItem;
    } else if (str == "toolbar") {
        m_itemType = ToolBar;
    } else if (str == "toolbutton") {
        m_itemType = ToolButton;
    } else if (str == "slider") {
        m_itemType = Slider;
    } else if (str == "frame") {
        m_itemType = Frame;
    } else if (str == "combobox") {
        m_itemType = ComboBox;
    } else if (str == "splitter") {
        m_itemType = Splitter;
    } else if (str == "progressbar") {
        m_itemType = ProgressBar;
    } else if (str == "button") {
        m_itemType = Button;
    } else if (str == "checkbox") {
        m_itemType = CheckBox;
    } else if (str == "radiobutton") {
        m_itemType = RadioButton;
    } else if (str == "edit") {
        m_itemType = Edit;
    } else if (str == "spinbox") {
        m_itemType = SpinBox;
    } else if (str == "scrollbar") {
        m_itemType = ScrollBar;
    } else if (str == "widget") {
        m_itemType = Widget;
    } else if (str == "focusframe") {
        m_itemType = FocusFrame;
    } else if (str == "dial") {
        m_itemType = Dial;
    } else if (str == "statusbar") {
        m_itemType = StatusBar;
    } else if (str == "machelpbutton") {
        m_itemType = MacHelpButton;
    } else if (str == "scrollareacorner") {
        m_itemType = ScrollAreaCorner;
    } else if (str == "menubar") {
        m_itemType = MenuBar;
    } else if (str == "menubaritem") {
        m_itemType = MenuBarItem;
    } else {
        m_itemType = Undefined;
    }
    updateSizeHint();
}

QRectF QStyleItem::subControlRect(const QString &subcontrolString)
{
    QStyle::SubControl subcontrol = QStyle::SC_None;
    initStyleOption();
    switch (m_itemType) {
    case SpinBox:
    {
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
                                             subcontrol);

    }
        break;
    case Slider:
    {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_SliderHandle;
        else if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_SliderGroove;
        return qApp->style()->subControlRect(control,
                                             qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                             subcontrol);

    }
        break;
    case ScrollBar:
    {
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
                                             subcontrol);
    }
        break;
    default:
        break;
    }
    return QRectF();
}

void QStyleItem::paint(QPainter *painter)
{
    if (width() < 1 || height() <1)
        return;

    initStyleOption();

    switch (m_itemType) {
    case Button:
        qApp->style()->drawControl(QStyle::CE_PushButton, m_styleoption, painter);
        break;
    case ItemRow :{
        QPixmap pixmap;
        // Only draw through style once
        const QString pmKey = QLatin1Literal("itemrow") % QString::number(m_styleoption->state,16) % activeControl();
        if (!QPixmapCache::find(pmKey, pixmap) || pixmap.width() < width() || height() != pixmap.height()) {
            int newSize = width();
            pixmap = QPixmap(newSize, height());
            pixmap.fill(Qt::transparent);
            QPainter pixpainter(&pixmap);
            qApp->style()->drawPrimitive(QStyle::PE_PanelItemViewRow, m_styleoption, &pixpainter);
            if (!qApp->style()->styleHint(QStyle::SH_ItemView_ShowDecorationSelected) && selected())
                pixpainter.fillRect(m_styleoption->rect, m_styleoption->palette.highlight());
            QPixmapCache::insert(pmKey, pixmap);
        }
        painter->drawPixmap(0, 0, pixmap);
    }
        break;
    case Item:
        qApp->style()->drawControl(QStyle::CE_ItemViewItem, m_styleoption, painter);
        break;
    case Header:
        qApp->style()->drawControl(QStyle::CE_Header, m_styleoption, painter);
        break;
    case ToolButton:

#ifdef Q_OS_MAC
        if (style() == "mac" && hint().indexOf("segmented") != -1) {
            const QPaintDevice *target = painter->device();
             HIThemeSegmentDrawInfo sgi;
            sgi.version = 0;
            sgi.state = isEnabled() ? kThemeStateActive : kThemeStateDisabled;
            if (sunken()) sgi.state |= kThemeStatePressed;
            sgi.size = kHIThemeSegmentSizeNormal;
            sgi.kind = kHIThemeSegmentKindTextured;
            sgi.value = on() && !sunken() ? kThemeButtonOn : kThemeButtonOff;

            sgi.adornment |= kHIThemeSegmentAdornmentLeadingSeparator;
            if (sunken()) {
                sgi.adornment |= kHIThemeSegmentAdornmentTrailingSeparator;
            }
            SInt32 button_height;
            GetThemeMetric(kThemeMetricButtonRoundedHeight, &button_height);
            sgi.position = info() == "leftmost" ? kHIThemeSegmentPositionFirst:
                                                  info() == "rightmost" ? kHIThemeSegmentPositionLast :
                                                               info() == "h_middle" ? kHIThemeSegmentPositionMiddle :
                                                                                   kHIThemeSegmentPositionOnly;
            QRect centered = m_styleoption->rect;
            centered.setHeight(button_height);
            centered.moveCenter(m_styleoption->rect.center());
            HIRect hirect = qt_hirectForQRect(centered.translated(0, -1), QRect(0, 0, 0, 0));
            HIThemeDrawSegment(&hirect, &sgi, qt_mac_cg_context(target), kHIThemeOrientationNormal);
        } else
#endif
        qApp->style()->drawComplexControl(QStyle::CC_ToolButton, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter);
        break;
    case Tab:
        qApp->style()->drawControl(QStyle::CE_TabBarTab, m_styleoption, painter);
        break;
    case Frame:
        qApp->style()->drawControl(QStyle::CE_ShapedFrame, m_styleoption, painter);
        break;
    case FocusFrame:
        if (style() == "mac" && hint().indexOf("rounded") != -1)
            break; // embedded in the line itself
        else
            qApp->style()->drawControl(QStyle::CE_FocusFrame, m_styleoption, painter);
        break;
    case TabFrame:
        qApp->style()->drawPrimitive(QStyle::PE_FrameTabWidget, m_styleoption, painter);
        break;
    case MenuBar:
        qApp->style()->drawControl(QStyle::CE_MenuBarEmptyArea, m_styleoption, painter);
        break;
    case MenuBarItem:
        qApp->style()->drawControl(QStyle::CE_MenuBarItem, m_styleoption, painter);
        break;
    case MenuItem:
    case ComboBoxItem: // fall through
        qApp->style()->drawControl(QStyle::CE_MenuItem, m_styleoption, painter);
        break;
    case CheckBox:
        qApp->style()->drawControl(QStyle::CE_CheckBox, m_styleoption, painter);
        break;
    case RadioButton:
        qApp->style()->drawControl(QStyle::CE_RadioButton, m_styleoption, painter);
        break;
    case Edit: {
#ifdef Q_OS_MAC
        if (style() == "mac" && hint().indexOf("rounded") != -1) {
            const QPaintDevice *target = painter->device();
            HIThemeFrameDrawInfo fdi;
            fdi.version = 0;
            fdi.state = kThemeStateActive;
            SInt32 frame_size;
            GetThemeMetric(kThemeMetricEditTextFrameOutset, &frame_size);
            fdi.kind = kHIThemeFrameTextFieldRound;
            if ((m_styleoption->state & QStyle::State_ReadOnly) || !(m_styleoption->state & QStyle::State_Enabled))
                fdi.state = kThemeStateInactive;
            fdi.isFocused = hasFocus();
            HIRect hirect = qt_hirectForQRect(m_styleoption->rect,
                                              QRect(frame_size, frame_size,
                                                    frame_size * 2, frame_size * 2));
            HIThemeDrawFrame(&hirect, &fdi, qt_mac_cg_context(target), kHIThemeOrientationNormal);
        } else
#endif
        qApp->style()->drawPrimitive(QStyle::PE_PanelLineEdit, m_styleoption, painter);
    }
        break;
    case MacHelpButton:
#ifdef Q_OS_MAC
    {
        const QPaintDevice *target = painter->device();
        HIThemeButtonDrawInfo fdi;
        fdi.kind = kThemeRoundButtonHelp;
        fdi.version = 0;
        fdi.adornment = 0;
        fdi.state = sunken() ? kThemeStatePressed : kThemeStateActive;
        HIRect hirect = qt_hirectForQRect(m_styleoption->rect,QRect(0, 0, 0, 0));
        HIThemeDrawButton(&hirect, &fdi, qt_mac_cg_context(target), kHIThemeOrientationNormal, NULL);
    }
#endif
        break;
    case Widget:
        qApp->style()->drawPrimitive(QStyle::PE_Widget, m_styleoption, painter);
        break;
    case ScrollAreaCorner:
        qApp->style()->drawPrimitive(QStyle::PE_PanelScrollAreaCorner, m_styleoption, painter);
        break;
    case Splitter:
        if (m_styleoption->rect.width() == 1)
            painter->fillRect(0, 0, width(), height(), m_styleoption->palette.dark().color());
        else
            qApp->style()->drawControl(QStyle::CE_Splitter, m_styleoption, painter);
        break;
    case ComboBox:
    {
        qApp->style()->drawComplexControl(QStyle::CC_ComboBox,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        // This is needed on mac as it will use the painter color and ignore the palette
        QPen pen = painter->pen();
        painter->setPen(m_styleoption->palette.text().color());
        qApp->style()->drawControl(QStyle::CE_ComboBoxLabel, m_styleoption, painter);
        painter->setPen(pen);
    }    break;
    case SpinBox:
        qApp->style()->drawComplexControl(QStyle::CC_SpinBox,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        break;
    case Slider:
        qApp->style()->drawComplexControl(QStyle::CC_Slider,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        break;
    case Dial:
        qApp->style()->drawComplexControl(QStyle::CC_Dial,
                                          qstyleoption_cast<QStyleOptionComplex*>(m_styleoption),
                                          painter);
        break;
    case ProgressBar:
        qApp->style()->drawControl(QStyle::CE_ProgressBar, m_styleoption, painter);
        break;
    case ToolBar:
        qApp->style()->drawControl(QStyle::CE_ToolBar, m_styleoption, painter);
        break;
    case StatusBar:
        if (style() == "mac") {
            m_styleoption->rect.adjust(0, 1, 0, 0);
            qApp->style()->drawControl(QStyle::CE_ToolBar, m_styleoption, painter);
            m_styleoption->rect.adjust(0, -1, 0, 0);
            painter->setPen(m_styleoption->palette.dark().color().darker(120));
            painter->drawLine(m_styleoption->rect.topLeft(), m_styleoption->rect.topRight());
        } else {
            qApp->style()->drawPrimitive(QStyle::PE_PanelToolBar, m_styleoption, painter);
        }
        break;
    case GroupBox:
        qApp->style()->drawComplexControl(QStyle::CC_GroupBox, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter);
        break;
    case ScrollBar:
        qApp->style()->drawComplexControl(QStyle::CC_ScrollBar, qstyleoption_cast<QStyleOptionComplex*>(m_styleoption), painter);
        break;
    case Menu: {
        QStyleHintReturnMask val;
        qApp->style()->styleHint(QStyle::SH_Menu_Mask, m_styleoption, 0, &val);
        painter->save();
        painter->setClipRegion(val.region);
        painter->fillRect(m_styleoption->rect, m_styleoption->palette.window());
        painter->restore();
        qApp->style()->drawPrimitive(QStyle::PE_PanelMenu, m_styleoption, painter);

        QStyleOptionFrame frame;
        frame.lineWidth = qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth);
        frame.midLineWidth = 0;
        frame.rect = m_styleoption->rect;
        qApp->style()->drawPrimitive(QStyle::PE_FrameMenu, &frame, painter);
    }
        break;
    default:
        break;
    }
}

int QStyleItem::textWidth(const QString &text)
{
    return QFontMetrics(m_font).boundingRect(text).width();
}

QString QStyleItem::elidedText(const QString &text, int elideMode, int width)
{
    return qApp->fontMetrics().elidedText(text, Qt::TextElideMode(elideMode), width);
}

bool QStyleItem::hasThemeIcon(const QString &icon) const
{
    return QIcon::hasThemeIcon(icon);
}
