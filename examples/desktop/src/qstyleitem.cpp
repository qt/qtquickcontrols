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


QStyleItem::QStyleItem(QDeclarativeItem *parent)
    : QDeclarativeItem(parent),
    m_sunken(false),
    m_raised(false),
    m_active(false),
    m_enabled(true),
    m_selected(false),
    m_focus(false),
    m_on(false),
    m_horizontal(true),
    m_minimum(0),
    m_maximum(100),
    m_value(0),
    m_dummywidget(0)
{
    setFlag(QGraphicsItem::ItemHasNoContents, false);
    setCacheMode(QGraphicsItem::DeviceCoordinateCache);
    setSmooth(true);
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

    opt->rect = QRect(x(), y(), width(), height());
}

QString QStyleItem::hitTest(int x, int y) const
{
    QStyle::SubControl subcontrol = QStyle::SC_All;
    QStyle::ComplexControl control = QStyle::CC_CustomBase;
    if (m_type == QLatin1String("spinbox")) {
        control = QStyle::CC_SpinBox;
        QStyleOptionSpinBox opt;
        opt.frame = true;
        initStyleOption(&opt);
        subcontrol = qApp->style()->hitTestComplexControl(control, &opt, QPoint(x,y), 0);
        if (subcontrol == QStyle::SC_SpinBoxUp)
            return "up";
        else if (subcontrol == QStyle::SC_SpinBoxDown)
            return "down";

    } else if (m_type == QLatin1String("slider")) {
        control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.sliderPosition = value();
        initStyleOption(&opt);
        subcontrol = qApp->style()->hitTestComplexControl(control, &opt, QPoint(x,y), 0);
        if (subcontrol == QStyle::SC_SliderHandle)
            return "handle";
    } else if (m_type == QLatin1String("scrollbar")) {
        control = QStyle::CC_ScrollBar;
        QStyleOptionSlider opt;
        initStyleOption(&opt);
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.pageStep = 100;
        opt.orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.sliderPosition = value();
        subcontrol = qApp->style()->hitTestComplexControl(control, &opt, QPoint(x,y), 0);
        if (subcontrol == QStyle::SC_ScrollBarSlider)
            return "handle";
    }
    return "none";
}

QRect QStyleItem::subControlRect(const QString &subcontrolString) const
{
    QStyle::SubControl subcontrol = QStyle::SC_None;
    if (m_type == QLatin1String("spinbox")) {
        QStyle::ComplexControl control = QStyle::CC_SpinBox;
        QStyleOptionSpinBox opt;
        opt.frame = true;
        initStyleOption(&opt);
        if (subcontrolString == QLatin1String("down"))
            subcontrol = QStyle::SC_SpinBoxDown;
        else if (subcontrolString == QLatin1String("up"))
            subcontrol = QStyle::SC_SpinBoxUp;
        return qApp->style()->subControlRect(control, &opt, subcontrol, 0);
    } else if (m_type == QLatin1String("slider")) {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.sliderPosition = value();
        initStyleOption(&opt);
        if (subcontrolString == QLatin1String("handle"))
            subcontrol = QStyle::SC_SliderHandle;
        else if (subcontrolString == QLatin1String("groove"))
            subcontrol = QStyle::SC_SliderGroove;
        return qApp->style()->subControlRect(control, &opt, subcontrol, 0);
    } else if (m_type == QLatin1String("scrollbar")) {
        QStyle::ComplexControl control = QStyle::CC_ScrollBar;
        QStyleOptionSlider opt;
        initStyleOption(&opt);
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.pageStep = 100;
        opt.orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.sliderPosition = value();
        if (subcontrolString == QLatin1String("slider"))
            subcontrol = QStyle::SC_ScrollBarSlider;
        else if (subcontrolString == QLatin1String("add"))
            subcontrol = QStyle::SC_ScrollBarAddPage;
        else if (subcontrolString == QLatin1String("sub"))
            subcontrol = QStyle::SC_ScrollBarSubPage;
        return qApp->style()->subControlRect(control, &opt, subcontrol, 0);
    }
}

void QStyleItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *)
{
    if (m_type == QLatin1String("button")) {
        QStyle::ControlElement control = QStyle::CE_PushButton;
        QStyleOptionButton opt;
        initStyleOption(&opt);
        qApp->style()->drawControl(control, &opt, painter, 0);
    } if (m_type == QLatin1String("menu")) {
        QStyle::PrimitiveElement control = QStyle::PE_PanelMenu;
        QStyleOptionFrameV3 opt;
        opt.lineWidth = 1;
        initStyleOption(&opt);
        qApp->style()->drawPrimitive(control, &opt, painter, 0);
    } if (m_type == QLatin1String("frame")) {
        QStyle::PrimitiveElement control = QStyle::PE_Frame;
        QStyleOptionFrameV3 opt;
        opt.frameShape = QFrame::StyledPanel;
        opt.lineWidth = 1;
        initStyleOption(&opt);
        qApp->style()->drawPrimitive(control, &opt, painter, 0);
    } if (m_type == QLatin1String("menuitem")) {
        QStyle::ControlElement control = QStyle::CE_MenuItem;
        QStyleOptionMenuItem opt;
        opt.text = text();
        initStyleOption(&opt);
        qApp->style()->drawControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("checkbox")) {
        QStyle::ControlElement control = QStyle::CE_CheckBox;
        QStyleOptionButton opt;
        initStyleOption(&opt);
        opt.text = text();
        qApp->style()->drawControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("radiobutton")) {
        QStyle::ControlElement control = QStyle::CE_RadioButton;
        QStyleOptionButton opt;
        initStyleOption(&opt);
        opt.text = text();
        qApp->style()->drawControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("edit")) {
        QStyle::PrimitiveElement control = QStyle::PE_PanelLineEdit;
        QStyleOptionFrameV3 opt;
        opt.lineWidth = 1; // jens : this must be non-zero
        initStyleOption(&opt);
        qApp->style()->drawPrimitive(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("slidergroove")) {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        opt.minimum = 0;
        opt.maximum = 100;
        opt.subControls |= (QStyle::SC_SliderGroove);
        opt.activeSubControls = QStyle::SC_SliderHandle;
        initStyleOption(&opt);
        qApp->style()->drawComplexControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("combobox")) {
        QStyle::ComplexControl control = QStyle::CC_ComboBox;
        QStyleOptionComboBox opt;
        initStyleOption(&opt);
        qApp->style()->drawComplexControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("spinbox")) {
        QStyle::ComplexControl control = QStyle::CC_SpinBox;
        QStyleOptionSpinBox opt;
        opt.frame = true;
        initStyleOption(&opt);
        if (value() & 0x1)
            opt.activeSubControls = QStyle::SC_SpinBoxUp;
        else if (value() & (1<<1))
            opt.activeSubControls = QStyle::SC_SpinBoxDown;
        opt.subControls |= QStyle::SC_SpinBoxDown;
        opt.subControls |= QStyle::SC_SpinBoxUp;
        if (value() & (1<<2))
            opt.stepEnabled |= QAbstractSpinBox::StepUpEnabled;
        if (value() & (1<<3))
            opt.stepEnabled |= QAbstractSpinBox::StepDownEnabled;
        qApp->style()->drawComplexControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("slider")) {
        QStyle::ComplexControl control = QStyle::CC_Slider;
        QStyleOptionSlider opt;
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.sliderPosition = value();
        opt.subControls |= (QStyle::SC_SliderGroove);
        opt.activeSubControls = QStyle::SC_SliderHandle;
        initStyleOption(&opt);
        qApp->style()->drawComplexControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("progressbar")) {
        QStyle::ControlElement control = QStyle::CE_ProgressBar;
        QStyleOptionProgressBarV2 opt;
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.progress = value();
        initStyleOption(&opt);
        qApp->style()->drawControl(control, &opt, painter, 0);
    } else if (m_type == QLatin1String("toolbar")) {
        QStyle::ControlElement control = QStyle::CE_ToolBar;
        QStyleOptionToolBar opt;
        initStyleOption(&opt);
        QMainWindow mw;
        QWidget w(&mw);
        qApp->style()->drawControl(control, &opt, painter, &w);
    } else if (m_type == QLatin1String("groupbox")) {
        QStyle::ComplexControl control = QStyle::CC_GroupBox;
        QStyleOptionGroupBox opt;
        initStyleOption(&opt);
        opt.text = text();
        opt.lineWidth = 1;
        opt.subControls = QStyle::SC_GroupBoxLabel;
        // oxygen crashes if we dont pass a widget
        qApp->style()->drawComplexControl(control, &opt, painter, &m_dummywidget);
    } else if (m_type == QLatin1String("scrollbar")) {
        QStyle::ComplexControl control = QStyle::CC_ScrollBar;
        QStyleOptionSlider opt;
        opt.minimum = minimum();
        opt.maximum = maximum();
        opt.pageStep = 100;
        opt.orientation = horizontal() ? Qt::Horizontal : Qt::Vertical;
        opt.sliderPosition = value();
        opt.activeSubControls = QStyle::SC_SliderHandle;
        initStyleOption(&opt);
        qApp->style()->drawComplexControl(control, &opt, painter, &m_dummywidget);
    }
}
