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


QStyleItem::QStyleItem(QObject*parent)
    : QObject(parent),
    m_dummywidget(0),
    m_sunken(false),
    m_raised(false),
    m_active(true),
    m_enabled(true),
    m_selected(false),
    m_focus(false),
    m_on(false),
    m_horizontal(true),
    m_minimum(0),
    m_maximum(100),
    m_value(0)
{
}

void QStyleItem::initStyleOption(QStyleOption *opt) const
{
    if (m_enabled)
        opt->state |= QStyle::State_Enabled;
    if (m_active)
        opt->state |= QStyle::State_Active;
    if (m_sunken)
        opt->state |= QStyle::State_Sunken;
    if (m_raised)
        opt->state |= QStyle::State_Raised;
    if (m_selected)
        opt->state |= QStyle::State_Selected;
    if (m_focus)
        opt->state |= QStyle::State_HasFocus;
    if (m_on)
        opt->state |= QStyle::State_On;
    if (m_hover)
        opt->state |= QStyle::State_MouseOver;
    if (m_horizontal)
        opt->state |= QStyle::State_Horizontal;
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
        style = style.left(style.length()-5);
    return style.toLower();
}

QString QStyleBackground::hitTest(int px, int py) const
{
    QStyle::SubControl subcontrol = QStyle::SC_All;
    QStyle::ComplexControl control = QStyle::CC_CustomBase;
    QString type = m_style->elementType();
    if (type == QLatin1String("spinbox")) {
        control = QStyle::CC_SpinBox;
        QStyleOptionSpinBox opt;
        opt.rect = QRect(0, 0, width(), height());
        opt.frame = true;
        m_style->initStyleOption(&opt);
        subcontrol = qApp->style()->hitTestComplexControl(control, &opt, QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_SpinBoxUp)
            return "up";
        else if (subcontrol == QStyle::SC_SpinBoxDown)
            return "down";

    } else if (type == QLatin1String("slider")) {
        control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        opt.rect = QRect(0, 0, width(), height());
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.sliderPosition = m_style->value();
        m_style->initStyleOption(&opt);
        subcontrol = qApp->style()->hitTestComplexControl(control, &opt, QPoint(px,py), 0);
        if (subcontrol == QStyle::SC_SliderHandle)
            return "handle";
    } else if (type == QLatin1String("scrollbar")) {
        control = QStyle::CC_ScrollBar;
        QStyleOptionSlider opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.pageStep = 200;
        opt.orientation = m_style->horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.sliderPosition = m_style->value();
        subcontrol = qApp->style()->hitTestComplexControl(control, &opt, QPoint(px,py), 0);

        if (subcontrol == QStyle::SC_ScrollBarSlider)
            return "handle";
        if (subcontrol == QStyle::SC_ScrollBarSubLine || subcontrol == QStyle::SC_ScrollBarSubPage)
            return "up";
        if (subcontrol == QStyle::SC_ScrollBarAddLine || subcontrol == QStyle::SC_ScrollBarAddPage)
            return "down";
    }
    return "none";
}

QSize QStyleItem::sizeFromContents(int width, int height)
{
    QString metric = m_type;
    if (metric == QLatin1String("checkbox")) {
        QStyleOptionButton opt;
        initStyleOption(&opt);
        opt.text = text();
        return qApp->style()->sizeFromContents(QStyle::CT_CheckBox, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("toolbutton")) {
        QStyleOptionToolButton opt;
        initStyleOption(&opt);
        opt.icon = qApp->style()->standardIcon(QStyle::SP_ArrowBack);
        return qApp->style()->sizeFromContents(QStyle::CT_ToolButton, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("button")) {
        QStyleOptionButton opt;
        initStyleOption(&opt);
        opt.text = text();
        return qApp->style()->sizeFromContents(QStyle::CT_PushButton, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("tab")) {
        QStyleOptionTabV3 opt;
        initStyleOption(&opt);
        opt.text = text();
        return qApp->style()->sizeFromContents(QStyle::CT_TabBarTab, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("combobox")) {
        QStyleOptionComboBox opt;
        initStyleOption(&opt);
        return qApp->style()->sizeFromContents(QStyle::CT_ComboBox, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("spinbox")) {
        QStyleOptionSpinBox opt;
        initStyleOption(&opt);
        return qApp->style()->sizeFromContents(QStyle::CT_SpinBox, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("slider")) {
        QStyleOptionSlider opt;
        initStyleOption(&opt);
        return qApp->style()->sizeFromContents(QStyle::CT_Slider, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("progressbar")) {
        QStyleOptionSlider opt;
        initStyleOption(&opt);
        return qApp->style()->sizeFromContents(QStyle::CT_ProgressBar, &opt, QSize(width,height), widget());
    } else if (metric == QLatin1String("edit")) {
        QStyleOptionFrameV3 opt;
        initStyleOption(&opt);
        return qApp->style()->sizeFromContents(QStyle::CT_LineEdit, &opt, QSize(width,height), widget());
    }
    return QSize();
}

int QStyleItem::pixelMetric(const QString &metric)
{
    if (metric == "scrollbarExtent")
        return qApp->style()->pixelMetric(QStyle::PM_ScrollBarExtent, 0 , widget());
    else if (metric == "defaultframewidth")
        return qApp->style()->pixelMetric(QStyle::PM_DefaultFrameWidth, 0 , widget());
    else if (metric == "taboverlap")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarTabOverlap, 0 , widget());
    else if (metric == "tabbaseoverlap")
        return qApp->style()->pixelMetric(QStyle::PM_TabBarBaseOverlap, 0 , widget());
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
    return 0;
}

QVariant QStyleItem::styleHint(const QString &metric)
{
    if (metric == "comboboxpopup") {
        QStyleOptionComboBox opt;
        opt.editable = false;
        return qApp->style()->styleHint(QStyle::SH_ComboBox_Popup, &opt);
    }
    if (metric == "focuswidget")
        return qApp->style()->styleHint(QStyle::SH_FocusFrame_AboveWidget);
    if (metric == "tabbaralignment") {
        int result = qApp->style()->styleHint(QStyle::SH_TabBar_Alignment);
        if (result == Qt::AlignCenter)
            return "center";
        return "left";
    }
    if (metric == "framearoundcontents")
        return qApp->style()->styleHint(QStyle::SH_ScrollView_FrameOnlyAroundContents);
    return 0;
}

void QStyleItem::setElementType(const QString &str)
{
    if (m_type == str)
        return;

    m_type = str;
    emit elementTypeChanged();

    if (m_dummywidget) {
        delete m_dummywidget;
        m_dummywidget = 0;
    }
    // Only enable visible if the widget can animate
    bool visible = false;
    if (str == "menu" || str == "menuitem") {
        // Since these are used by the delegate, it makes no
        // sense to re-create them per item
        static QWidget *menu = new QMenu();
        m_dummywidget = menu;
    } if (str == "groupbox") {
        // Since these are used by the delegate, it makes no
        // sense to re-create them per item
        static QGroupBox *group = new QGroupBox();
        m_dummywidget = group;
    } else if (str == "comboboxitem")  {
        // Gtk uses qobject cast, hence we need to separate this from menuitem
        // On mac, we temporarily use the menu item because it has more accurate
        // palette.
#ifdef Q_WS_MAC
        static QMenu *combo = new QMenu();
#else
        static QComboBox *combo = new QComboBox();
#endif
        m_dummywidget = combo;
    } else if (str == "toolbar") {
        static QToolBar *tb = 0;
        if (!tb) {
            QMainWindow *mw = new QMainWindow();
            tb = new QToolBar(mw);
        }
        m_dummywidget = tb;
    } else if (str == "slider") {
        static QSlider *slider = new QSlider();
        m_dummywidget = slider;
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
    } else if (str == "scrollbar") {
        m_dummywidget = new QScrollBar();
        visible = true;
    }

    if (m_dummywidget) {
        m_dummywidget->installEventFilter(this);
        m_dummywidget->setAttribute(Qt::WA_QuitOnClose, false); // dont keep app open
        m_dummywidget->winId();
#ifdef Q_WS_MAC
        m_dummywidget->setVisible(visible);// Mac require us to set the visibility before this
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

void QStyleBackground::showToolTip(const QString &str) const
{
    QPointF scene = mapToScene(width() - 20, 0);
    QPoint global = qApp->focusWidget()->mapToGlobal(scene.toPoint());
    QToolTip::showText(QPoint(global.x(), global.y()), str);
}

QRect QStyleBackground::subControlRect(const QString &subcontrolString) const
{
    QStyle::SubControl subcontrol = QStyle::SC_None;
    QString m_type = m_style->elementType();
    if (m_type == QLatin1String("spinbox")) {
        QStyle::ComplexControl control = QStyle::CC_SpinBox;
        QStyleOptionSpinBox opt;
        m_style->initStyleOption(&opt);
        opt.rect = QRect(0, 0, width(), height());
        opt.frame = true;
        if (subcontrolString == QLatin1String("down"))
            subcontrol = QStyle::SC_SpinBoxDown;
        else if (subcontrolString == QLatin1String("up"))
            subcontrol = QStyle::SC_SpinBoxUp;
        else if (subcontrolString == QLatin1String("edit")){
            subcontrol = QStyle::SC_SpinBoxEditField;
        }
        return qApp->style()->subControlRect(control, &opt, subcontrol, 0);
    } else if (m_type == QLatin1String("slider")) {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        m_style->initStyleOption(&opt);
        opt.rect = QRect(0, 0, width(), height());
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.sliderPosition = m_style->value();
        if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_SliderHandle;
        else if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_SliderGroove;
        return qApp->style()->subControlRect(control, &opt, subcontrol, 0);
    } else if (m_type == QLatin1String("scrollbar")) {
        QStyle::ComplexControl control = QStyle::CC_ScrollBar;
        QStyleOptionSlider opt;
        m_style->initStyleOption(&opt);
        opt.rect = QRect(0, 0, width(), height());
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.pageStep = m_style->horizontal() ? width() : height();
        opt.orientation = m_style->horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.sliderPosition = m_style->value();
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
        return qApp->style()->subControlRect(control, &opt, subcontrol, 0);
    }
    return QRect();
}

QStyleBackground::QStyleBackground(QDeclarativeItem *parent)
    : QDeclarativeItem(parent),
      m_style(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    setCacheMode(QGraphicsItem::DeviceCoordinateCache);
    setSmooth(true);
}

void QStyleBackground::setStyle(QStyleItem *style)
{   
    if (m_style != style) {
        m_style = style;
        connect(m_style, SIGNAL(updateItem()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(infoChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(onChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(selectedChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(activeChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(textChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(activeChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(raisedChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(sunkenChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(hoverChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(maximumChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(minimumChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(valueChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(enabledChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(horizontalChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(focusChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(activeControlChanged()), this, SLOT(updateItem()));
        connect(m_style, SIGNAL(elementTypeChanged()), this, SLOT(updateItem()));
        emit styleChanged();
    }
}


void QStyleBackground::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    if (!m_style)
        return;

    QString type = m_style->elementType();
    if (type == QLatin1String("button")) {
        QStyle::ControlElement control = QStyle::CE_PushButton;
        QStyleOptionButton opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        m_style->widget()->resize(width(), height());
        opt.text = m_style->text();
        if (m_style->activeControl() == "default")
            opt.features |= QStyleOptionButton::DefaultButton;

        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("toolbutton")) {
        QStyle::ComplexControl control = QStyle::CC_ToolButton;
        QStyleOptionToolButton opt;
        m_style->initStyleOption(&opt);
        opt.subControls = QStyle::SC_ToolButton;
        opt.rect = QRect(0, 0, width(), height());
        QToolBar bar;
        if (opt.state & QStyle::State_Raised || opt.state & QStyle::State_On)
            qApp->style()->drawComplexControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("tab")) {
        QStyle::ControlElement control = QStyle::CE_TabBarTab;
        QStyleOptionTabV3 opt;
        m_style->initStyleOption(&opt);
        int overlap = qApp->style()->pixelMetric(QStyle::PM_TabBarTabOverlap);
        opt.rect = QRect(overlap, 0, width()-2*overlap, height());
        opt.text = m_style->text();
        if (m_style->info() == "South")
            opt.shape = QTabBar::RoundedSouth;
        if (m_style->activeControl() == QLatin1String("beginning"))
            opt.position = QStyleOptionTabV3::Beginning;
        else if (m_style->activeControl() == QLatin1String("end"))
            opt.position = QStyleOptionTabV3::End;
        else if (m_style->activeControl() == QLatin1String("only"))
            opt.position = QStyleOptionTabV3::OnlyOneTab;
        else
            opt.position = QStyleOptionTabV3::Middle;
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("menu")) {
        QStyleOptionMenuItem opt;
        if (QMenu *menu = qobject_cast<QMenu*>(m_style->widget())){
            opt.palette = menu->palette();
        }
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        QStyleHintReturnMask val;
        qApp->style()->styleHint(QStyle::SH_Menu_Mask, &opt, m_style->widget(), &val);
        painter->save();
        painter->setClipRegion(val.region);
        painter->fillRect(opt.rect, opt.palette.window());
        painter->restore();
        qApp->style()->drawPrimitive(QStyle::PE_PanelMenu, &opt, painter, m_style->widget());
        QStyleOptionFrame frame;
        m_style->initStyleOption(&frame);
        frame.lineWidth = qApp->style()->pixelMetric(QStyle::PM_MenuPanelWidth);
        frame.midLineWidth = 0;
        frame.rect = opt.rect;
        qApp->style()->drawPrimitive(QStyle::PE_FrameMenu, &frame, painter, m_style->widget());
        //       qApp->style()->drawControl(QStyle::CE_MenuVMargin, &opt, painter, m_menu);
    }
    else if (type == QLatin1String("frame")) {
        QStyle::ControlElement control = QStyle::CE_ShapedFrame;
        QStyleOptionFrameV3 opt;
        m_style->initStyleOption(&opt);
        opt.rect = QRect(0, 0, width(), height());
        opt.frameShape = QFrame::StyledPanel;
        opt.lineWidth = 1;
        opt.midLineWidth = 1;
        qApp->style()->drawControl(control, &opt, painter, 0);
    }
    else if (type == QLatin1String("focusframe")) {
        QStyle::ControlElement control = QStyle::CE_FocusFrame;
        QStyleOption opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("tabframe")) {
        QStyle::PrimitiveElement control = QStyle::PE_FrameTabWidget;
        if (m_style->minimum()) {
            QStyleOptionTabWidgetFrameV2 opt;
            m_style->initStyleOption(&opt);
            if (m_style->info() == "South")
                opt.shape = QTabBar::RoundedSouth;
            opt.selectedTabRect = QRect(m_style->value(), 0, m_style->minimum(), height());
            opt.rect = QRect(0, 0, width(), height());
            qApp->style()->drawPrimitive(control, &opt, painter, m_style->widget());
        } else {
            QStyleOptionTabWidgetFrame opt;
            m_style->initStyleOption(&opt);
            opt.rect = QRect(0, 0, width(), height());
            qApp->style()->drawPrimitive(control, &opt, painter, m_style->widget());
        }
    }
    else if (type == QLatin1String("menuitem") || type == QLatin1String("comboboxitem")) {
        QStyle::ControlElement control = QStyle::CE_MenuItem;
        QStyleOptionMenuItem opt;
        m_style->initStyleOption(&opt);
        opt.checked = false;
        opt.rect = QRect(0, 0, width(), height());
        opt.text = m_style->text();
        opt.palette = m_style->widget()->palette();
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("checkbox")) {
        QStyle::ControlElement control = QStyle::CE_CheckBox;
        QStyleOptionButton opt;
        m_style->initStyleOption(&opt);
        if (!(opt.state & QStyle::State_On))
            opt.state |= QStyle::State_Off;
        opt.rect = QRect(0, 0, width(), height());
        opt.text = m_style->text();
        m_style->widget()->resize(width(), height());
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("radiobutton")) {
        QStyle::ControlElement control = QStyle::CE_RadioButton;
        QStyleOptionButton opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.text = m_style->text();
        m_style->widget()->resize(width(), height());
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("edit")) {
        QStyle::PrimitiveElement control = QStyle::PE_PanelLineEdit;
        QStyleOptionFrameV3 opt;
        opt.rect = QRect(0, 0, width(), height());
        opt.lineWidth = 1; // jens : this must be non-zero
        m_style->initStyleOption(&opt);
        qApp->style()->drawPrimitive(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("combobox")) {
        QStyle::ComplexControl control = QStyle::CC_ComboBox;
        QStyleOptionComboBox opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        m_style->widget()->resize(width(), height());
        opt.currentText = m_style->text();
        qApp->style()->drawComplexControl(control, &opt, painter, m_style->widget());
        qApp->style()->drawControl(QStyle::CE_ComboBoxLabel, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("spinbox")) {
        QStyle::ComplexControl control = QStyle::CC_SpinBox;
        QStyleOptionSpinBox opt;
        opt.rect = QRect(0, 0, width(), height());
        opt.frame = true;
        m_style->initStyleOption(&opt);
        if (m_style->value() & 0x1)
            opt.activeSubControls = QStyle::SC_SpinBoxUp;
        else if (m_style->value() & (1<<1))
            opt.activeSubControls = QStyle::SC_SpinBoxDown;
        opt.subControls |= QStyle::SC_SpinBoxDown;
        opt.subControls |= QStyle::SC_SpinBoxUp;
        if (m_style->value() & (1<<2))
            opt.stepEnabled |= QAbstractSpinBox::StepUpEnabled;
        if (m_style->value() & (1<<3))
            opt.stepEnabled |= QAbstractSpinBox::StepDownEnabled;
        qApp->style()->drawComplexControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("slider")) {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        m_style->widget()->resize(width(), height());
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        if (m_style->activeControl() == "ticks")
            opt.tickPosition = QSlider::TicksBelow;
        opt.sliderPosition = m_style->value();
        opt.tickInterval = 1200 / (opt.maximum - opt.minimum);
        opt.sliderValue = m_style->value();
        opt.subControls = QStyle::SC_SliderTickmarks | QStyle::SC_SliderGroove | QStyle::SC_SliderHandle;
        opt.activeSubControls = QStyle::SC_None;
        qApp->style()->drawComplexControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("dial")) {
        QStyle::ComplexControl control = QStyle::CC_Dial;
        QStyleOptionSlider opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.tickPosition = QSlider::TicksBelow;
        opt.sliderPosition = m_style->value();
        opt.tickInterval = 1200 / (opt.maximum - opt.minimum);
        opt.sliderValue = m_style->value();
        opt.subControls = QStyle::SC_SliderTickmarks | QStyle::SC_SliderGroove | QStyle::SC_SliderHandle;
        opt.activeSubControls = QStyle::SC_None;
        qApp->style()->drawComplexControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("progressbar")) {
        if (QProgressBar *bar= qobject_cast<QProgressBar*>(m_style->widget())){
            bar->setMaximum(m_style->maximum());
            bar->setMinimum(m_style->minimum());
            if (m_style->maximum() != m_style->minimum())
                bar->setValue(1);
        }
        QStyle::ControlElement control = QStyle::CE_ProgressBar;
        QStyleOptionProgressBarV2 opt;
        opt.orientation = m_style->horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.progress = m_style->value();
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("toolbar")) {
        QStyle::ControlElement control = QStyle::CE_ToolBar;
        QStyleOptionToolBar opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        qApp->style()->drawControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("groupbox")) {
        if (QGroupBox *group= qobject_cast<QGroupBox*>(m_style->widget())){
            group->setTitle(m_style->text());
        }
        QStyle::ComplexControl control = QStyle::CC_GroupBox;
        QStyleOptionGroupBox opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.text = m_style->text();
        opt.lineWidth = 1;
        opt.subControls = QStyle::SC_GroupBoxLabel;
        // oxygen crashes if we dont pass a widget
        qApp->style()->drawComplexControl(control, &opt, painter, m_style->widget());
    }
    else if (type == QLatin1String("scrollbar")) {
        QScrollBar *bar = qobject_cast<QScrollBar *>(m_style->widget());
        bar->setMaximum(m_style->maximum());
        bar->setMinimum(m_style->minimum());
        bar->setValue(m_style->value());
        bar->resize(width(), height());

        QStyle::ComplexControl control = QStyle::CC_ScrollBar;
        QStyleOptionSlider opt;
        opt.rect = QRect(0, 0, width(), height());
        m_style->initStyleOption(&opt);
        opt.minimum = m_style->minimum();
        opt.maximum = m_style->maximum();
        opt.pageStep = m_style->horizontal() ? width() : height();
        opt.orientation = m_style->horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.sliderPosition = m_style->value();
        opt.sliderValue = m_style->value();
        opt.activeSubControls = (m_style->activeControl() == QLatin1String("up"))
                                ? QStyle::SC_ScrollBarSubLine :
                                (m_style->activeControl() == QLatin1String("down")) ?
                                QStyle::SC_ScrollBarAddLine:
                                QStyle::SC_ScrollBarSlider;

        opt.sliderValue = m_style->value();
        opt.subControls = QStyle::SC_All;
        qApp->style()->drawComplexControl(control, &opt, painter, bar);
    }
}
