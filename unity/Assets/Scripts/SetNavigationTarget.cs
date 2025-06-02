using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.InputSystem;

public class SetNavigationTarget : MonoBehaviour
{
    [SerializeField]
    private List<GameObject> floorContainers = new List<GameObject>(); // قائمة تحتوي على GameObject لكل طابق

    [SerializeField]
    private GameObject arrowPrefab;

    [SerializeField]
    private float arrowSpacing = 1.0f;

    [SerializeField]
    private float arrowOffset = 1.0f;

    private NavMeshPath path;
    private List<GameObject> arrows = new List<GameObject>();
    private Vector3 targetPosition = Vector3.zero;
    private bool lineToggle = false;
    private InputAction touchAction;

    private void Awake()
    {
        path = new NavMeshPath();
        touchAction = new InputAction("Touch", binding: "<Touchscreen>/touch*/press");
        touchAction.Enable();
    }

    private void OnDestroy()
    {
        touchAction.Disable();
    }

    private void Update()
    {
        if (lineToggle)
        {
            bool pathFound = NavMesh.CalculatePath(transform.position, targetPosition, NavMesh.AllAreas, path);
            if (pathFound && path.corners.Length > 0)
            {
                DrawPath();
            }
            else
            {
                ClearPath();
            }
        }
        else
        {
            ClearPath();
        }

        UpdateArrowTransparency();
    }

    private void DrawPath()
    {
        ClearPath();

        List<Vector3> smoothedPath = SmoothPath(path.corners);

        for (int i = 0; i < smoothedPath.Count - 1; i++)
        {
            Vector3 start = smoothedPath[i];
            Vector3 end = smoothedPath[i + 1];
            Vector3 direction = (end - start).normalized;

            float distance = Vector3.Distance(start, end);
            int numArrows = Mathf.FloorToInt(distance / arrowSpacing);

            Vector3 position = start + direction * arrowOffset;

            for (int j = 0; j < numArrows; j++)
            {
                if (j > 0)
                {
                    position += direction * arrowSpacing;
                }
                GameObject arrow = Instantiate(arrowPrefab, position, Quaternion.LookRotation(direction));
                arrows.Add(arrow);
            }
        }
    }

    private void ClearPath()
    {
        foreach (var arrow in arrows)
        {
            Destroy(arrow);
        }
        arrows.Clear();
    }

    public void OnRoomSelectedFromFilter(string roomNumber)
    {
        targetPosition = Vector3.zero;
        GameObject foundRoom = FindRoomByNumber(roomNumber);

        if (foundRoom != null)
        {
            targetPosition = foundRoom.transform.position;
            lineToggle = true; // تشغيل المسار تلقائيًا عند العثور على الغرفة
            Debug.Log($"Navigation set to room: {roomNumber}");
        }
        else
        {
            Debug.LogWarning($"Room {roomNumber} not found in any floor!");
        }
    }

    private GameObject FindRoomByNumber(string roomNumber)
    {
        foreach (var floor in floorContainers) // البحث في كل طابق
        {
            foreach (Transform room in floor.transform) // البحث بين الغرف داخل الطابق
            {
                if (room.name == roomNumber)
                {
                    return room.gameObject;
                }
            }
        }
        return null; // لم يتم العثور على الغرفة
    }

    public void ToggleVisibility()
    {
        lineToggle = !lineToggle;
        if (!lineToggle)
        {
            ClearPath();
        }
    }

    private List<Vector3> SmoothPath(Vector3[] corners)
    {
        List<Vector3> smoothedPath = new List<Vector3>();

        if (corners.Length < 2)
            return smoothedPath;

        smoothedPath.Add(corners[0]); // أول نقطة في المسار

        for (int i = 0; i < corners.Length - 1; i++)
        {
            Vector3 p0 = corners[i];
            Vector3 p1 = corners[i + 1];

            int extraPoints = 5; // عدد النقاط الإضافية بين كل زاويتين

            for (int j = 1; j <= extraPoints; j++)
            {
                float t = (float)j / (extraPoints + 1);
                Vector3 intermediatePoint = Vector3.Lerp(p0, p1, t); // توليد نقطة بينية سلسة
                smoothedPath.Add(intermediatePoint);
            }

            smoothedPath.Add(p1);
        }

        return smoothedPath;
    }

    private void UpdateArrowTransparency()
    {
        if (arrows.Count == 0) return;

        float totalDistance = 0;
        for (int i = 0; i < path.corners.Length - 1; i++)
        {
            totalDistance += Vector3.Distance(path.corners[i], path.corners[i + 1]);
        }

        float currentDistance = 0;
        for (int i = 0; i < arrows.Count; i++)
        {
            float alpha = 1.0f;
            if (i > 0)
            {
                currentDistance += Vector3.Distance(arrows[i - 1].transform.position, arrows[i].transform.position);
                alpha = Mathf.Clamp01(1 - (currentDistance / totalDistance));
            }
            SetArrowAlpha(arrows[i], alpha);
        }
    }

    private void SetArrowAlpha(GameObject arrow, float alpha)
    {
        Renderer renderer = arrow.GetComponent<Renderer>();
        if (renderer != null)
        {
            foreach (Material mat in renderer.materials)
            {
                Color color = mat.color;
                color.a = alpha;
                mat.color = color;
            }
        }
    }
}
