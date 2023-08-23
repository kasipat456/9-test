report 90010 "Recursive_Funtion"
{
    DefaultLayout = RDLC;
    ApplicationArea = All;
    RDLCLayout = 'Layouts/StandardRecursiveConf.rdl';
    Caption = 'Recursive_Funtion';


    ////////////////////////////////////////////////////ข้อที่9/////////////////////////////////////////////////////////

    dataset
    {

        dataitem(RecursiveTable_Item; RecursiveTable)
        {
            //-------------------------------------------------------------------- Column
            Column(Item; Item)//-----Item
            { }
            column(Parent; Parent)//----Parent
            { }
            column(ItemRecursive_Var; ItemRecursive_Var)
            { }
            //-----------------------------------------------------------------------------//
            //trigger OnPostDataItem() begin end; ---> ดำเนินการหลังจากประมวลผลข้อมูลแล้ว ***นำไปใช้กับ รายการข้อมูล
            //trigger OnPreDataItem() begin end; ---> ดำเนินการก่อนที่รายการข้อมูลจะถูกประมวลผล ***นำไปใช้กับ รายการข้อมูล
            //trigger OnAfterGetRecord() begin end; ---> ดำเนินการทุกครั้งที่มีการดึงข้อมูลจากรายการข้อมูล ***นำไปใช้กับ รายการข้อมูล
            //-----------------------------------------------------------------------------//
            trigger OnAfterGetRecord() //ส่งไปที่รายงาน
            var
                Commar1: Text;
            begin
                ItemRecursive_Var := ''; //ถ้าไม่ใส่ค่าอันนี้ มันจำซ้ำชุดก่อนหน้า
                tmp.DeleteAll();
                saveRecursive(Item); //---ดึงแบบนี้จะมาหลังที่วนครบ 7 รอบแล้วเป็น 7-1
                tmp.Reset();
                Commar1 := ',';
                if tmp.FindSet() then begin

                    repeat
                        if ItemRecursive_Var <> '' then begin // ถ้า ItemRecursive_Var มีค่าให้ทำงาน
                            ItemRecursive_Var += commar1;
                        end;
                        if Tmp.Item <> Item then begin //-------- ถ้า Tmp.Item ไม่เท่ากับ Item

                            ItemRecursive_Var += tmp.Item;
                        end;

                    until tmp.Next() = 0;
                end;
            end;

            trigger OnPreDataItem() //ดำเนินการก่อนที่รายการข้อมูลจะถูกประมวลผล ------ทำครั้งเดียว
            begin
                saveRecursive(Item);
            end;

        }
    }

    //-----------------------------------------------------------------------------//
    //trigger OnInitReport ()// var myInt: Integer; --->ดำเนินการเมื่อโหลดรายงาน ***นำไปใช้กับ รายงาน
    //begin end;
    //trigger OnPostReport() //var myInt: Integer; --->ดำเนินการหลังจากรันรายงาน ***นำไปใช้กับ รายงาน
    //begin end;
    //trigger OnPreReport() //var myInt: Intergerl ---> ดำเนินการก่อนเรียกใช้รายงาน ***นำไปใช้กับ รายงาน*** เราต้องชี้ก่อน1ตัวแล้วค่อยวน
    //begin end;
    //-----------------------------------------------------------------------------//
    procedure saveRecursive(Var CodeItem: Code[30])
    var
        tmpItem: Record RecursiveTable;
    begin
        RecurseFunction(CodeItem); //-----เรียกวนตัวฟังชั่น
        //tmpItem.Reset(); ///-----------------ไม่จำเป็นต้องใส่ค่ารีเซตเพราะมันรีเซตค่าข้างบนอยู่แล้ว
        tmpItem.SetCurrentKey(Parent, Item); //เรียง 
        tmpItem.SetRange(Parent, CodeItem);
        if tmpItem.FindSet() then begin
            repeat
                saveRecursive(tmpItem.Item);
            until tmpItem.Next = 0;
        end;

    end;

    procedure RecurseFunction(Var CodeItem: Code[30])//--------Item_Loop: Text;

    begin
        tmp.Reset(); //------------รีเซตค่าเข้ามาทุกๆรอบ
        tmp.SetRange(Item, CodeItem); //-------- item == CodeItem ''==''
        //tmpItem.SetCurrentKey(Item, Parent); //-----จัดเรียง ระเบียนที่มีเขตข้อมูลที่คุณจัดเรียงเนื้อหาของตารางและที่คุณระบุคีย์ที่คุณต้องการเลือก
        if not tmp.FindSet() then begin //--------------------------- not tmp.FindSet() 
            // tmp.Item = CodeItem; จากการเขียนsodo มันทำให้รู้ค่าว่า tmp.Item = CodeItem
            if codeItem <> '' then begin
                tmp.Init();
                // tmp.Item := tmpItem.Item; ดังนั้น codeItem = tmp.Item
                tmp.Item := CodeItem;
                tmp.Insert();
            end;
        end;
    end;




    var
        tmp: Record RecursiveTable temporary; //-----------------------Temporary Recursive_Temporary
        ItemRecursive_Var: Text;//--------------Parent
        SearchItem: Text;
        I: Integer;

}
