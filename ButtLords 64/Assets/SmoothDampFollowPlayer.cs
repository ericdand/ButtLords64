using UnityEngine;
using System.Collections;

public class SmoothDampFollowPlayer : MonoBehaviour {

	public Transform target;

	private Vector2 velocity;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		transform.position = Vector2.SmoothDamp (transform.position, target.position, ref velocity, 0.15f);
	}
}
