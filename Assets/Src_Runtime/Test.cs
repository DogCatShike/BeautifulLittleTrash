using UnityEngine;

public class Test : MonoBehaviour {
    public Material targetMaterial;
    public float revealDuration = 3f;
    public float fadeDuration = 2f;

    private float timer = 0f;
    private bool isRevealed = false;

    void Update() {
        timer += Time.deltaTime;

        if (!isRevealed) {
            float progress = Mathf.Clamp01(timer / revealDuration);
            targetMaterial.SetFloat("_CutoffY", progress);

            if (progress >= 1f) {
                isRevealed = true;
                timer = 0f;
            }
        }
        else {
            float fade = Mathf.Clamp01(1 - (timer / fadeDuration));
            targetMaterial.SetFloat("_Fade", fade);
        }
    }

    void OnDestroy() {
        // 重置参数
        targetMaterial.SetFloat("_CutoffY", 0);
        targetMaterial.SetFloat("_Fade", 1);
    }
}