object FrmMain: TFrmMain
  Width = 640
  Height = 425
  Caption = 'Your Weather'
  CSSLibrary = cssBootstrap
  ElementFont = efCSS
  OnCreate = WebFormCreate
  object Icon: TWebImageControl
    Left = 160
    Top = 119
    Width = 100
    Height = 100
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
    ChildOrder = 2
  end
  object txtDescription: TWebLabel
    Left = 8
    Top = 225
    Width = 400
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'txtDescription'
    ElementFont = efCSS
    HeightStyle = ssAuto
    HeightPercent = 100.000000000000000000
    HTMLType = tSPAN
    WidthPercent = 100.000000000000000000
  end
  object txtLocationText: TWebLabel
    Left = 8
    Top = 65
    Width = 400
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'WebLabel1'
    ElementClassName = 'fs-3'
    ElementFont = efCSS
    HeightStyle = ssAuto
    HeightPercent = 100.000000000000000000
    HTMLType = tSPAN
    WidthPercent = 100.000000000000000000
  end
  object txtLocationNumbers: TWebLabel
    Left = 8
    Top = 98
    Width = 400
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'WebLabel1'
    ElementClassName = 'fs-6'
    ElementFont = efCSS
    HeightStyle = ssAuto
    HeightPercent = 100.000000000000000000
    HTMLType = tSPAN
    WidthPercent = 100.000000000000000000
  end
  object txtHeader: TWebLabel
    Left = 8
    Top = 16
    Width = 400
    Height = 15
    Alignment = taCenter
    AutoSize = False
    Caption = 'Your Weather Forecast'
    ElementClassName = 'display-4'
    ElementFont = efCSS
    HeightStyle = ssAuto
    HeightPercent = 100.000000000000000000
    HTMLType = tH1
    WidthPercent = 100.000000000000000000
  end
  object Grid: TWebTableControl
    Left = 8
    Top = 259
    Width = 400
    Height = 134
    HeightStyle = ssAuto
    BorderColor = clSilver
    ChildOrder = 4
    ElementFont = efCSS
    ElementHeaderClassName = 'thead-light'
    ElementTableClassName = 'table table-striped table-bordered  table-hover'
    Footer.ButtonActiveElementClassName = 'btn btn-primary'
    Footer.ButtonElementClassName = 'btn btn-light'
    Footer.DropDownElementClassName = 'form-control'
    Footer.InputElementClassName = 'form-control'
    Footer.LinkActiveElementClassName = 'link-primary'
    Footer.LinkElementClassName = 'link-secondary'
    Footer.ListElementClassName = 'pagination'
    Footer.ListItemElementClassName = 'page-item'
    Footer.ListLinkElementClassName = 'page-link'
    Header.ButtonActiveElementClassName = 'btn btn-primary'
    Header.ButtonElementClassName = 'btn btn-light'
    Header.DropDownElementClassName = 'form-control'
    Header.InputElementClassName = 'form-control'
    Header.LinkActiveElementClassName = 'link-primary'
    Header.LinkElementClassName = 'link-secondary'
    Header.ListElementClassName = 'pagination'
    Header.ListItemElementClassName = 'page-item'
    Header.ListLinkElementClassName = 'page-link'
    RowHeader = False
    ColCount = 2
    RowCount = 4
  end
end
