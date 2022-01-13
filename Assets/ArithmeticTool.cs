using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//==============================
//Synopsis  :  
//CreatTime :  #CREATETIME#
//For       :  #AUTHORNAME#
//==============================

public class ArithmeticTool : MonoBehaviour
{
  //**@return单元排序后的数组 */
  private static int sortUnit(int[] array, int low, int high)
  {
    int key = array[low];
    while (low < high)
    {
      /*从后向前搜索比key小的值*/
      while (array[high] >= key && high > low)
        --high;
      /*比key小的放左边*/
      array[low] = array[high];
      /*从前向后搜索比key大的值，比key大的放右边*/
      while (array[low] <= key && high > low)
        ++low;
      /*比key大的放右边*/
      array[high] = array[low];
    }
    /*左边都比key小，右边都比key大。//将key放在游标当前位置。//此时low等于high */
    array[low] = key;
    foreach (int i in array)
    {
      Debug.Log($"{i}\t");
    }
    return high;
  }
  /**快速排序 
*@paramarry 
*@return */
  public static void sort(int[] array, int low, int high)
  {
    if (low >= high)
      return;
    /*完成一次单元排序*/
    int index = sortUnit(array, low, high);
    /*对左边单元进行排序*/
    sort(array, low, index - 1);
    /*对右边单元进行排序*/
    sort(array, index + 1, high);
  }
}

