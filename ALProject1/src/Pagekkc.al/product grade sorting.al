page 90024 "product grade sorting"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "product grade sorting header";
    RefreshOnActivate = true;


    layout
    {
        area(Content)
        {

            group(Information)
            {
                field("Document No"; Rec."Document No")
                {
                    ApplicationArea = All;
                    Lookup = false;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then //  OnAssistEdit Trigger เพื่อเปลี่ยนพฤติกรรมการช่วยแก้ไขเริ่มต้น 
                                                     //xRecแสดงถึงเรคคอร์ดก่อนที่จะถูกแก้ไข
                                                     //Recถึงข้อมูลเรคคอร์ดปัจจุบันที่อยู่ระหว่างดำเนินการ

                            CurrPage.Update(); // CurrPage = หน้านี้  Update = อัพเดช  รวมคือเมื่อมีการทำอะไรกับ Field นี้จะมีการอัพเดช
                    end;

                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; Rec."Employee No")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                }
            }
            //---------------------------------------------------------------------------------------------------------------
            group(คัดแยกเกรด)
            {
                grid(MyGrid)
                {
                    Caption = 'เกรด A';
                    group("เกรด A")
                    {
                        field("Item A"; Rec."Item A")
                        {
                            ApplicationArea = All;
                        }
                    }
                    grid("จำนวน A")
                    {
                        field("Grade A"; Rec."Grade A")
                        {
                            ApplicationArea = all;
                        }
                    }
                }
                grid(MyGrid2)
                {
                    group("เกรด Scap")
                    {
                        Caption = 'เกรด Scap';
                        field("Item Scap"; Rec."Item Scap")
                        {
                            ApplicationArea = All;
                        }
                    }
                    grid("จำนวน Scap")
                    {
                        field("Grade Scap"; Rec."Grade Scap")
                        {
                            ApplicationArea = all;
                            trigger OnValidate()
                            begin
                                //Message('%1 %2', Rec."Grade C", xRec."Grade C");
                                if test1(Rec."Grade Scap", Rec) then begin // ส่งค่า field Grade Scap / Rec = Header
                                    Error('จำนวน Scap ห้ามเกิน A');
                                end;
                            end;
                        }
                    }
                }
                grid(MyGrid3)
                {
                    group("เกรด C")
                    {
                        Caption = 'เกรด C';
                        field("Item C"; Rec."Item C")
                        {
                            ApplicationArea = All;
                        }
                    }

                    grid("จำนวน C")
                    {
                        field("Grade C"; Rec."Grade C")
                        {
                            ApplicationArea = all;
                            trigger OnValidate()
                            begin
                                //Message('%1 %2', Rec."Grade C", xRec."Grade C");
                                if test(Rec."Grade C", Rec) then begin
                                    Error('จำนวน C ห้ามเกิน A');
                                end;

                            end;
                        }
                    }
                }

            }
            //---------------------------------------------------------------------------------------------
            group(Variance)
            {
                grid(MyGrid4)
                {
                    group(เกรดC)
                    {
                        field("grade C number"; Rec."grade C number")
                        {
                            ApplicationArea = All;
                            Style = Strong;  // ใส่สีดำตัวหนา
                        }
                    }
                    grid(Grid5)
                    {
                        field("C Var.%"; Rec."C Var.%")
                        {
                            ApplicationArea = All;
                            Style = Strong; // ใส่สีดำตัวหนา
                        }
                    }
                }
                grid(Grid)
                {
                    group(เกรดScap)
                    {
                        field("Grade Scap number"; Rec."Grade Scap number")
                        {
                            ApplicationArea = All;
                            Style = Unfavorable; // สีแดงตัวหนา
                        }
                    }
                    grid(Grid6)
                    {
                        field("Scap Var.%"; Rec."Scap Var.%")
                        {
                            ApplicationArea = All;
                            Style = Unfavorable; // สีแดงตัวหนา
                        }
                    }
                }
                grid(Grid7)
                {
                    group(เกรดA)
                    {
                        field("Grade A number"; Rec."Grade A number")
                        {
                            ApplicationArea = All;
                            Style = Favorable; // สีเขียว 
                        }
                    }
                    grid(Grid8)
                    {
                        field("A. Var.%"; Rec."A. Var.%")
                        {
                            ApplicationArea = All;
                            Style = Favorable; // สีเขียว 
                        }
                    }
                }
                grid(Grid9)
                {
                    group(รวมจำนวนที่Scap)
                    {
                        field(Total; Rec.Total)
                        {
                            Caption = 'จำนวน';
                            ApplicationArea = All;
                            Style = Strong; // ใส่สีดำตัวหนา

                        }
                    }
                }
            }
            part("product grade sorting line"; Lines)
            {
                ApplicationArea = All;
                SubPageLink = "Document No" = FIELD("Document No");
                UpdatePropagation = Both;
            }

        }

    }

    actions
    {
        area(Processing)
        {
            action(CalVariance)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Quatity();

                end;
            }
        }

    }
    procedure Quatity()
    var
        Header: Record "product grade sorting header";
        QuarityA: Decimal;  // ประกาศตัวแปร เพื่อมาเก็บค่าของตัวแปร
        SumQuatity: Decimal;
    begin
        Clear(QuarityA); // ลบค่าของ Quality A ออกให้หมดก่อน 
        Header.Reset();
        Header.SetRange("Document No", Rec."Document No"); // setrange หาตัวที่เหมือนกัน
        if Header.findset() then begin // เลือกข้อมูลทั้งหมดที่อยู่ใน Header

            QuarityA := Header."Grade A" - Header."Grade C" - Header."Grade Scap";

            Header."grade C number" := Header."Grade C";
            Header."C Var.%" := (Header."Grade C" / Header."Grade A") * 100;

            Header."Grade Scap number" := Header."Grade Scap";
            Header."Scap Var.%" := (Header."Grade Scap" / Header."Grade A") * 100;

            Header."Grade A number" := QuarityA;
            Header."A. Var.%" := (QuarityA / Header."Grade A") * 100;

            // SumQuatity := Header."Grade Scap number" - Header."Grade C number";
            // Header.Total := SumQuatity;

            Header.Modify();

            Message('QuarityA%1', QuarityA);
            Message('Header%1', Header."A. Var.%");
            // Message('SumQuatity%1', SumQuatity);

        end;
    end;







    // ค่าในช่องเกรด C
    procedure test(GradeC: Decimal; Rec: Record "product grade sorting header"): Boolean
    var
        hd: Record "product grade sorting header";
        TotalGrade: Decimal; // ประกาศตัวแปร 
    begin
        Clear(TotalGrade); // ลบค่าทั้งหมด TotalGrade ทั้งหมด เพื่อไม่ให้ไปคิดค่าเดิม
        TotalGrade := Rec."Grade Scap" + GradeC;
        // Message('%1 %2', Rec."Grade Scap", GradeC);
        if TotalGrade > rec."Grade A" then begin // ถ้า TotalGrade มากกว่า A 
            exit(true);
        end;
    end;

    // ค่าในช่องเกรด Scap
    procedure test1(Gradescap: Decimal; Rec: Record "product grade sorting header"): Boolean
    var
        hd: Record "product grade sorting header";
        Total: Decimal;
    begin
        Clear(Total);
        Total := rec."Grade C" + Gradescap;
        if Total > rec."Grade A" then begin
            // Message('%1 %2', b, rec."Grade A");
            exit(true)
        end;
    end;


}