using UnityEngine;
using System.Collections;

public class IndicatorTracker : MonoBehaviour
{
    private Vector3 lastPosition; // آخر موقع محفوظ
    private float updateInterval = 120f; // التحديث كل دقيقتين

    void Start()
    {
        lastPosition = transform.position;
        StartCoroutine(UpdatePositionRoutine());
    }

    void Update()
    {
        // تحقق إذا تغير موقع الـ Indicator
        if (transform.position != lastPosition)
        {
            lastPosition = transform.position;
            PrintPosition();
        }
    }

    IEnumerator UpdatePositionRoutine()
    {
        while (true)
        {
            yield return new WaitForSeconds(updateInterval);
            PrintPosition();
        }
    }

    void PrintPosition()
    {
        Debug.Log($"Indicator Position Updated: {transform.position}");
    }
}
