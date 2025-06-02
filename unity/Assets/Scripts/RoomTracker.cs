using UnityEngine;
using System.Collections.Generic;

public class RoomTracker : MonoBehaviour
{
    public Transform indicator; // المؤشر الذي يمثل المستخدم
    public GameObject[] floorContainers; // الطوابق التي تحتوي على الغرف
    private Dictionary<string, Transform> roomDictionary = new Dictionary<string, Transform>();

    void Start()
    {
        LoadRooms(); // تحميل الغرف عند بدء التشغيل
    }

    private void LoadRooms()
    {
        foreach (GameObject floor in floorContainers)
        {
            foreach (Transform room in floor.transform)
            {
                roomDictionary[room.name] = room; // تخزين الغرف في القاموس
            }
        }
        Debug.Log($"Loaded {roomDictionary.Count} rooms into dictionary.");
    }

    public void OnRoomNumberReceived(string scannedRoomNumber)
    {
        Debug.Log($"Received room number from Flutter: {scannedRoomNumber}");
        UpdateIndicatorPosition(scannedRoomNumber);
    }

    private void UpdateIndicatorPosition(string recognizedRoomNumber)
    {
        if (roomDictionary.TryGetValue(recognizedRoomNumber, out Transform room))
        {
            indicator.position = room.position; // نقل المؤشر إلى موقع الغرفة
            Debug.Log($"Indicator moved to room: {recognizedRoomNumber}");
        }
        else
        {
            Debug.LogWarning($"Room {recognizedRoomNumber} not found in the map!");
        }
    }
}
